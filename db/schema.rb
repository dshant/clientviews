# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_20_052017) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.string "subscription_status"
    t.datetime "trial_ends_at"
    t.string "plan_id"
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "api_keys", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.string "api_key"
    t.boolean "enabled"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_api_keys_on_account_id"
  end

  create_table "flipper_features", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "integrations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.string "type"
    t.jsonb "settings", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_integrations_on_account_id"
    t.index ["settings"], name: "index_integrations_on_settings", using: :gin
  end

  create_table "replies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "from"
    t.text "message"
    t.string "video_response"
    t.string "source"
    t.uuid "response_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["response_id"], name: "index_replies_on_response_id"
  end

  create_table "responses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "survey_id", null: false
    t.string "value"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "survey_type"
    t.string "video_feedback_data"
    t.string "extra_text"
    t.index ["survey_id"], name: "index_responses_on_survey_id"
  end

  create_table "site_survey_memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "site_id", null: false
    t.uuid "survey_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["site_id"], name: "index_site_survey_memberships_on_site_id"
    t.index ["survey_id"], name: "index_site_survey_memberships_on_survey_id"
  end

  create_table "sites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "domain"
    t.uuid "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_sites_on_account_id"
  end

  create_table "survey_notification_emails", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "survey_id", null: false
    t.string "email"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_survey_notification_emails_on_survey_id"
  end

  create_table "survey_response_webhooks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "survey_id", null: false
    t.string "name"
    t.string "url"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_survey_response_webhooks_on_survey_id"
  end

  create_table "survey_trigger_urls", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "survey_id", null: false
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_survey_trigger_urls_on_survey_id"
  end

  create_table "surveys", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "border_color"
    t.string "header"
    t.string "person_name"
    t.text "content"
    t.string "survey_type"
    t.uuid "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "position"
    t.uuid "site_id"
    t.boolean "email_collect"
    t.string "thank_you_note"
    t.integer "counter_max"
    t.string "rating_icon"
    t.boolean "hide_image", default: false, null: false
    t.string "video_feedback_enabled"
    t.string "trigger_type"
    t.integer "delay_time_number"
    t.string "delay_time_interval"
    t.string "notification_slack_channel"
    t.index ["account_id"], name: "index_surveys_on_account_id"
    t.index ["site_id"], name: "index_surveys_on_site_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.uuid "taggable_id"
    t.string "tagger_type"
    t.uuid "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "account_id", null: false
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "video_assets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "response_id", null: false
    t.string "provider"
    t.string "provider_id"
    t.string "provider_asset_id"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "playback_id"
    t.index ["response_id"], name: "index_video_assets_on_response_id"
  end

  create_table "visitor_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "visitor_token"
    t.uuid "survey_id", null: false
    t.string "event"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_visitor_events_on_survey_id"
  end

  create_table "visitor_identities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "visitor_token"
    t.string "uid"
    t.string "email"
    t.jsonb "extra_attributes", default: {}, null: false
    t.jsonb "account", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account"], name: "index_visitor_identities_on_account", using: :gin
    t.index ["extra_attributes"], name: "index_visitor_identities_on_extra_attributes", using: :gin
  end

  create_table "visits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "survey_id", null: false
    t.string "visit_token"
    t.string "visitor_token"
    t.string "ip"
    t.string "user_agent"
    t.string "referring_domain"
    t.string "full_location"
    t.string "path"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id", "visit_token", "path"], name: "index_visits_on_survey_id_and_visit_token_and_path"
    t.index ["survey_id"], name: "index_visits_on_survey_id"
  end

  create_table "zaps", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "survey_id", null: false
    t.string "zapier_id"
    t.string "hook_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_zaps_on_survey_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "api_keys", "accounts"
  add_foreign_key "integrations", "accounts"
  add_foreign_key "replies", "responses"
  add_foreign_key "responses", "surveys"
  add_foreign_key "site_survey_memberships", "sites"
  add_foreign_key "site_survey_memberships", "surveys"
  add_foreign_key "sites", "accounts"
  add_foreign_key "survey_notification_emails", "surveys"
  add_foreign_key "survey_response_webhooks", "surveys"
  add_foreign_key "survey_trigger_urls", "surveys"
  add_foreign_key "surveys", "accounts"
  add_foreign_key "taggings", "tags"
  add_foreign_key "users", "accounts"
  add_foreign_key "video_assets", "responses"
  add_foreign_key "visitor_events", "surveys"
  add_foreign_key "visits", "surveys"
  add_foreign_key "zaps", "surveys"
end
