file_path = "config/plans.yml"
if File.exist?(file_path)
  PLANS = YAML.load(File.read(file_path)).with_indifferent_access.dig(Rails.env)
end
