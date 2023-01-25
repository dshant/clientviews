module ActiveJob
  module Exceptions
    module ClassMethods
      def retry_on(*exceptions, wait: 3.seconds, attempts: 5, queue: nil, priority: nil, callback: nil)
        rescue_from(*exceptions) do |error|
          executions = executions_for(exceptions)

          if executions < attempts
            yield self, error if block_given?
            retry_job wait: determine_delay(seconds_or_duration_or_algorithm: wait, executions: executions), queue: queue, priority: priority, error: error
          else
            if block_given?
              instrument :retry_stopped, error: error do
                yield self, error
              end
            else
              instrument :retry_stopped, error: error
              raise error
            end
          end
        end
      end
    end
  end
end