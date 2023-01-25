class Plan
  # PlanStruct = Struct.new(:surveys, :responses, :integrations, :amount, :stripe_price_id, :active, :displayable)
  class NotFoundError < StandardError; end
  def self.plans
    @plans ||= PLANS.keys.map { |k| PLANS[k] }
  end

  def self.all
    plans.map { |plan| OpenStruct.new(plan) }
  end

  def self.where(args)
    conditions = args.map do |arg_key, arg_val|
      proc { |plan| plan[arg_key] == arg_val }
    end
    local_plans = plans.select { |plan| conditions.all? { |c| c.call(plan) } }
    return [] if local_plans.empty?

    local_plans.flatten.map { |plan| OpenStruct.new(plan) }
  end

  def self.find(stripe_id)
    plan = plans.find { |p| p[:stripe_price_id] == stripe_id }
    raise NotFoundError, "Could not find Plan with stripe_price_id: #{stripe_id}" unless plan

    OpenStruct.new(plan)
  end

  def self.find_by(args)
    plan = Plan.where(args)&.first
    return nil if plan.nil?

    OpenStruct.new(plan)
  end

  def self.find_by!(args)
    plan = Plan.where(args)&.first
    raise NotFoundError, "Could not find Plan with #{args.to_a.flatten.first}: #{args.to_a.flatten.last}" unless plan

    OpenStruct.new(plan)
  end
end
