# Be sure to restart your server when you modify this file.

# ActiveSupport::Reloader.to_prepare do
#   ApplicationController.renderer.defaults.merge!(
#     http_host: 'example.org',
#     https: false
#   )
# end

ActionView::Base.field_error_proc = proc do |html_tag, instance|
  puts "h #{html_tag}\ni #{instance.inspect}"
  html = %(<div class="field_with_errors">#{html_tag}</div>).html_safe
  # add nokogiri gem to Gemfile
  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css 'label, input'
  elements.each do |e|
    if e.node_name.eql? 'label'
      html = e.to_s.html_safe
    elsif e.node_name.eql? 'input'
      if !instance.error_message.is_a?(String)
        html = %(<div class="field_with_errors">#{html_tag}<div class="text-danger small" role="alert">&nbsp;#{instance.error_message.join(', ')}</div></div>).html_safe
      else
        html = %(<div class="field_with_errors">#{html_tag}<div class="text-danger small" role="alert">&nbsp;#{instance.error_message}</div></div>).html_safe
      end
    end
  end
  html
end
