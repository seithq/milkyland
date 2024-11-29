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

ActiveRecord::Schema[8.1].define(version: 2024_11_28_223821) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "join_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "batches", force: :cascade do |t|
    t.bigint "production_unit_id", null: false
    t.bigint "machiner_id", null: false
    t.bigint "tester_id", null: false
    t.bigint "operator_id", null: false
    t.bigint "loader_id", null: false
    t.integer "status"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "work_shift", default: "daily"
    t.bigint "storage_id", null: false
    t.index ["loader_id"], name: "index_batches_on_loader_id"
    t.index ["machiner_id"], name: "index_batches_on_machiner_id"
    t.index ["operator_id"], name: "index_batches_on_operator_id"
    t.index ["production_unit_id"], name: "index_batches_on_production_unit_id"
    t.index ["storage_id"], name: "index_batches_on_storage_id"
    t.index ["tester_id"], name: "index_batches_on_tester_id"
  end

  create_table "box_packagings", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "material_asset_id", null: false
    t.integer "count"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["material_asset_id"], name: "index_box_packagings_on_material_asset_id"
    t.index ["product_id", "material_asset_id"], name: "index_box_packagings_on_product_id_and_material_asset_id", unique: true
    t.index ["product_id"], name: "index_box_packagings_on_product_id"
  end

  create_table "box_requests", force: :cascade do |t|
    t.bigint "generation_id", null: false
    t.bigint "box_packaging_id", null: false
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["box_packaging_id"], name: "index_box_requests_on_box_packaging_id"
    t.index ["generation_id"], name: "index_box_requests_on_generation_id"
  end

  create_table "boxes", force: :cascade do |t|
    t.string "code"
    t.bigint "region_id", null: false
    t.bigint "product_id", null: false
    t.integer "capacity"
    t.date "production_date"
    t.date "expiration_date"
    t.bigint "box_request_id"
    t.datetime "scanned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["box_request_id"], name: "index_boxes_on_box_request_id"
    t.index ["code"], name: "index_boxes_on_code", unique: true
    t.index ["product_id"], name: "index_boxes_on_product_id"
    t.index ["region_id"], name: "index_boxes_on_region_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.integer "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "bin"
    t.string "contact_person"
    t.string "job_title"
    t.string "phone_number"
    t.string "email_address"
    t.string "entity_code"
    t.string "bank_name"
    t.string "bank_account"
    t.string "bank_code"
    t.bigint "manager_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bin"], name: "index_clients_on_bin", unique: true
    t.index ["manager_id"], name: "index_clients_on_manager_id"
    t.index ["name"], name: "index_clients_on_name", unique: true
  end

  create_table "consolidations", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.bigint "order_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_consolidations_on_order_id"
    t.index ["plan_id", "order_id"], name: "index_consolidations_on_plan_id_and_order_id", unique: true
    t.index ["plan_id"], name: "index_consolidations_on_plan_id"
  end

  create_table "containers", force: :cascade do |t|
    t.bigint "packing_machine_id", null: false
    t.bigint "material_asset_id", null: false
    t.decimal "performance", precision: 20, scale: 2
    t.decimal "losses_percentage", precision: 20, scale: 2
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["material_asset_id"], name: "index_containers_on_material_asset_id"
    t.index ["packing_machine_id", "material_asset_id"], name: "index_containers_on_packing_machine_id_and_material_asset_id", unique: true
    t.index ["packing_machine_id"], name: "index_containers_on_packing_machine_id"
  end

  create_table "cooked_semi_products", force: :cascade do |t|
    t.bigint "cooking_id", null: false
    t.bigint "semi_product_id", null: false
    t.decimal "litrage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cooking_id"], name: "index_cooked_semi_products_on_cooking_id"
    t.index ["semi_product_id"], name: "index_cooked_semi_products_on_semi_product_id"
  end

  create_table "cookings", force: :cascade do |t|
    t.bigint "batch_id", null: false
    t.integer "status"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_cookings_on_batch_id"
  end

  create_table "discounted_products", force: :cascade do |t|
    t.bigint "promotion_id", null: false
    t.bigint "product_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_discounted_products_on_product_id"
    t.index ["promotion_id", "product_id"], name: "index_discounted_products_on_promotion_id_and_product_id", unique: true
    t.index ["promotion_id"], name: "index_discounted_products_on_promotion_id"
  end

  create_table "distributed_products", force: :cascade do |t|
    t.bigint "distribution_id", null: false
    t.bigint "packaged_product_id", null: false
    t.bigint "region_id", null: false
    t.date "production_date"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["distribution_id"], name: "index_distributed_products_on_distribution_id"
    t.index ["packaged_product_id"], name: "index_distributed_products_on_packaged_product_id"
    t.index ["region_id"], name: "index_distributed_products_on_region_id"
  end

  create_table "distributions", force: :cascade do |t|
    t.bigint "batch_id", null: false
    t.integer "status"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_distributions_on_batch_id"
  end

  create_table "fields", force: :cascade do |t|
    t.bigint "operation_id", null: false
    t.string "name"
    t.string "kind"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chain_order", default: 0
    t.bigint "measurement_id"
    t.bigint "standard_id"
    t.string "collection"
    t.string "trigger"
    t.bigint "trackable_id"
    t.integer "time_window"
    t.index ["measurement_id"], name: "index_fields_on_measurement_id"
    t.index ["operation_id", "name"], name: "index_fields_on_operation_id_and_name", unique: true
    t.index ["operation_id"], name: "index_fields_on_operation_id"
    t.index ["standard_id"], name: "index_fields_on_standard_id"
    t.index ["trackable_id"], name: "index_fields_on_trackable_id"
  end

  create_table "generation_downloads", force: :cascade do |t|
    t.bigint "generation_id", null: false
    t.string "kind"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["generation_id"], name: "index_generation_downloads_on_generation_id"
  end

  create_table "generations", force: :cascade do |t|
    t.bigint "distributed_product_id", null: false
    t.string "status"
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["distributed_product_id"], name: "index_generations_on_distributed_product_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.integer "metric_tonne"
    t.datetime "recipe_modified_at"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_groups_on_category_id"
    t.index ["name"], name: "index_groups_on_name", unique: true
  end

  create_table "ingredients", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "material_asset_id", null: false
    t.decimal "ratio", precision: 20, scale: 3
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_ingredients_on_group_id"
    t.index ["material_asset_id"], name: "index_ingredients_on_material_asset_id"
  end

  create_table "journals", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.string "name"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chain_order", default: 0
    t.index ["group_id", "name"], name: "index_journals_on_group_id_and_name", unique: true
    t.index ["group_id"], name: "index_journals_on_group_id"
  end

  create_table "leftovers", force: :cascade do |t|
    t.bigint "waybill_id", null: false
    t.bigint "storage_id", null: false
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.decimal "count", precision: 20, scale: 2
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_leftovers_on_parent_id"
    t.index ["storage_id"], name: "index_leftovers_on_storage_id"
    t.index ["subject_type", "subject_id"], name: "index_leftovers_on_subject"
    t.index ["waybill_id"], name: "index_leftovers_on_waybill_id"
  end

  create_table "lines", force: :cascade do |t|
    t.string "code"
    t.string "display_index"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_lines_on_code", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.string "storable_type", null: false
    t.bigint "storable_id", null: false
    t.string "positionable_type", null: false
    t.bigint "positionable_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["positionable_type", "positionable_id"], name: "index_locations_on_positionable"
    t.index ["storable_type", "storable_id"], name: "index_locations_on_storable"
  end

  create_table "material_assets", force: :cascade do |t|
    t.string "name"
    t.bigint "category_id", null: false
    t.bigint "supplier_id", null: false
    t.string "article"
    t.decimal "entry_price", precision: 20, scale: 2
    t.decimal "packing", precision: 10, scale: 3
    t.bigint "measurement_id", null: false
    t.integer "delivery_time_in_days"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article"], name: "index_material_assets_on_article", unique: true
    t.index ["category_id"], name: "index_material_assets_on_category_id"
    t.index ["measurement_id"], name: "index_material_assets_on_measurement_id"
    t.index ["name", "supplier_id"], name: "index_material_assets_on_name_and_supplier_id", unique: true
    t.index ["supplier_id"], name: "index_material_assets_on_supplier_id"
  end

  create_table "measurements", force: :cascade do |t|
    t.string "name"
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "tonne_ratio", precision: 20, scale: 3
    t.index ["unit"], name: "index_measurements_on_unit", unique: true
  end

  create_table "metrics", force: :cascade do |t|
    t.bigint "step_id", null: false
    t.bigint "field_id", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id"], name: "index_metrics_on_field_id"
    t.index ["step_id"], name: "index_metrics_on_step_id"
  end

  create_table "operations", force: :cascade do |t|
    t.bigint "journal_id", null: false
    t.string "name"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chain_order", default: 0
    t.index ["journal_id", "name"], name: "index_operations_on_journal_id_and_name", unique: true
    t.index ["journal_id"], name: "index_operations_on_journal_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "sales_channel_id", null: false
    t.bigint "client_id", null: false
    t.bigint "sales_point_id", null: false
    t.integer "kind"
    t.string "status"
    t.date "preferred_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["sales_channel_id"], name: "index_orders_on_sales_channel_id"
    t.index ["sales_point_id"], name: "index_orders_on_sales_point_id"
  end

  create_table "packaged_products", force: :cascade do |t|
    t.bigint "packing_id", null: false
    t.bigint "product_id", null: false
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.index ["packing_id", "product_id"], name: "index_packaged_products_on_packing_id_and_product_id", unique: true
    t.index ["packing_id"], name: "index_packaged_products_on_packing_id"
    t.index ["product_id"], name: "index_packaged_products_on_product_id"
  end

  create_table "packing_machines", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_packing_machines_on_name", unique: true
  end

  create_table "packings", force: :cascade do |t|
    t.bigint "batch_id", null: false
    t.integer "status"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_packings_on_batch_id"
  end

  create_table "pallet_requests", force: :cascade do |t|
    t.bigint "generation_id", null: false
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["generation_id"], name: "index_pallet_requests_on_generation_id"
  end

  create_table "pallets", force: :cascade do |t|
    t.string "code"
    t.bigint "pallet_request_id"
    t.datetime "scanned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_pallets_on_code", unique: true
    t.index ["pallet_request_id"], name: "index_pallets_on_pallet_request_id"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "promotion_id", null: false
    t.bigint "client_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_participants_on_client_id"
    t.index ["promotion_id", "client_id"], name: "index_participants_on_promotion_id_and_client_id", unique: true
    t.index ["promotion_id"], name: "index_participants_on_promotion_id"
  end

  create_table "plans", force: :cascade do |t|
    t.date "production_date"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
    t.string "kind", default: "standard"
  end

  create_table "positions", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.bigint "promotion_id"
    t.integer "count"
    t.decimal "base_price", precision: 20, scale: 3
    t.decimal "discounted_price", precision: 20, scale: 3
    t.decimal "total_sum", precision: 20, scale: 3
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_positions_on_order_id"
    t.index ["product_id"], name: "index_positions_on_product_id"
    t.index ["promotion_id"], name: "index_positions_on_promotion_id"
  end

  create_table "prices", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "sales_channel_id", null: false
    t.decimal "value", precision: 20, scale: 2
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "sales_channel_id"], name: "index_prices_on_product_id_and_sales_channel_id", unique: true
    t.index ["product_id"], name: "index_prices_on_product_id"
    t.index ["sales_channel_id"], name: "index_prices_on_sales_channel_id"
  end

  create_table "production_units", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.bigint "group_id", null: false
    t.integer "count"
    t.decimal "tonnage"
    t.integer "status"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_production_units_on_group_id"
    t.index ["plan_id", "group_id"], name: "index_production_units_on_plan_id_and_group_id", unique: true
    t.index ["plan_id"], name: "index_production_units_on_plan_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.string "name"
    t.string "article"
    t.decimal "packing", precision: 10, scale: 3
    t.bigint "measurement_id", null: false
    t.integer "expiration_in_days"
    t.string "storage_conditions"
    t.decimal "fat_fraction", precision: 20, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "material_asset_id"
    t.index ["article"], name: "index_products_on_article", unique: true
    t.index ["group_id"], name: "index_products_on_group_id"
    t.index ["material_asset_id"], name: "index_products_on_material_asset_id"
    t.index ["measurement_id"], name: "index_products_on_measurement_id"
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "promotions", force: :cascade do |t|
    t.string "name"
    t.string "kind"
    t.date "start_date"
    t.date "end_date"
    t.decimal "discount", precision: 20, scale: 2
    t.boolean "unlimited", default: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_promotions_on_name", unique: true
  end

  create_table "qr_scans", force: :cascade do |t|
    t.bigint "groupable_id", null: false
    t.string "code"
    t.string "sourceable_type", null: false
    t.bigint "sourceable_id", null: false
    t.bigint "box_id", null: false
    t.integer "capacity_before"
    t.integer "capacity_after"
    t.datetime "scanned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "groupable_type", default: "Waybill"
    t.index ["box_id"], name: "index_qr_scans_on_box_id"
    t.index ["groupable_id"], name: "index_qr_scans_on_groupable_id"
    t.index ["sourceable_type", "sourceable_id"], name: "index_qr_scans_on_sourceable"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_regions_on_code", unique: true
    t.index ["name"], name: "index_regions_on_name", unique: true
  end

  create_table "route_sheets", force: :cascade do |t|
    t.bigint "shipment_id", null: false
    t.string "vehicle_plate_number"
    t.string "driver_name"
    t.string "driver_phone_number"
    t.string "status"
    t.text "comment"
    t.boolean "generated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipment_id"], name: "index_route_sheets_on_shipment_id"
  end

  create_table "sales_channels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sales_channels_on_name", unique: true
  end

  create_table "sales_points", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "name"
    t.text "address"
    t.string "phone_number"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "region_id", null: false
    t.index ["client_id", "name"], name: "index_sales_points_on_client_id_and_name", unique: true
    t.index ["client_id"], name: "index_sales_points_on_client_id"
    t.index ["region_id"], name: "index_sales_points_on_region_id"
  end

  create_table "semi_ingredients", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "semi_product_id", null: false
    t.decimal "ratio", precision: 20, scale: 3
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_semi_ingredients_on_group_id"
    t.index ["semi_product_id"], name: "index_semi_ingredients_on_semi_product_id"
  end

  create_table "semi_products", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.string "name"
    t.bigint "measurement_id", null: false
    t.integer "expiration_in_days"
    t.string "storage_conditions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_semi_products_on_group_id"
    t.index ["measurement_id"], name: "index_semi_products_on_measurement_id"
    t.index ["name"], name: "index_semi_products_on_name", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "last_active_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_sessions_on_token", unique: true
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.bigint "plan_id"
    t.bigint "region_id", null: false
    t.bigint "client_id"
    t.date "shipping_date"
    t.string "kind"
    t.string "status"
    t.datetime "routes_changed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_shipments_on_client_id"
    t.index ["plan_id"], name: "index_shipments_on_plan_id"
    t.index ["region_id"], name: "index_shipments_on_region_id"
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "task_key", null: false
    t.datetime "run_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.string "key", null: false
    t.string "schedule", null: false
    t.string "command", limit: 2048
    t.string "class_name"
    t.text "arguments"
    t.string "queue_name"
    t.integer "priority", default: 0
    t.boolean "static", default: true, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "stacks", force: :cascade do |t|
    t.string "code"
    t.string "display_index"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_stacks_on_code", unique: true
  end

  create_table "standards", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "measurement_id", null: false
    t.string "name"
    t.decimal "from", precision: 10, scale: 2
    t.decimal "to", precision: 10, scale: 2
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "name"], name: "index_standards_on_group_id_and_name", unique: true
    t.index ["group_id"], name: "index_standards_on_group_id"
    t.index ["measurement_id"], name: "index_standards_on_measurement_id"
  end

  create_table "steps", force: :cascade do |t|
    t.bigint "batch_id", null: false
    t.bigint "operation_id", null: false
    t.integer "status"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id", "operation_id"], name: "index_steps_on_batch_id_and_operation_id", unique: true
    t.index ["batch_id"], name: "index_steps_on_batch_id"
    t.index ["operation_id"], name: "index_steps_on_operation_id"
  end

  create_table "storages", force: :cascade do |t|
    t.string "name"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_storages_on_name", unique: true
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "bin"
    t.string "contact_person"
    t.string "job_title"
    t.string "phone_number"
    t.string "email_address"
    t.string "entity_code"
    t.string "bank_name"
    t.string "bank_account"
    t.string "bank_code"
    t.bigint "manager_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bin"], name: "index_suppliers_on_bin", unique: true
    t.index ["manager_id"], name: "index_suppliers_on_manager_id"
    t.index ["name"], name: "index_suppliers_on_name", unique: true
  end

  create_table "supply_orders", force: :cascade do |t|
    t.bigint "material_asset_id", null: false
    t.decimal "amount", precision: 20, scale: 2
    t.date "payment_date"
    t.string "payment_status"
    t.string "delivery_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["material_asset_id"], name: "index_supply_orders_on_material_asset_id"
  end

  create_table "tiers", force: :cascade do |t|
    t.string "code"
    t.string "display_index"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_tiers_on_code", unique: true
  end

  create_table "tracking_products", force: :cascade do |t|
    t.bigint "route_sheet_id", null: false
    t.bigint "product_id", null: false
    t.integer "count"
    t.integer "unrestricted_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_tracking_products_on_product_id"
    t.index ["route_sheet_id"], name: "index_tracking_products_on_route_sheet_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.integer "role", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  create_table "warehousers", force: :cascade do |t|
    t.bigint "storage_id", null: false
    t.bigint "user_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "duty"
    t.bigint "replaceable_id"
    t.index ["replaceable_id"], name: "index_warehousers_on_replaceable_id"
    t.index ["storage_id"], name: "index_warehousers_on_storage_id"
    t.index ["user_id"], name: "index_warehousers_on_user_id"
  end

  create_table "waybills", force: :cascade do |t|
    t.string "kind"
    t.bigint "storage_id"
    t.bigint "new_storage_id"
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.bigint "batch_id"
    t.text "comment"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.boolean "manual_approval", default: false
    t.index ["batch_id"], name: "index_waybills_on_batch_id"
    t.index ["new_storage_id"], name: "index_waybills_on_new_storage_id"
    t.index ["receiver_id"], name: "index_waybills_on_receiver_id"
    t.index ["sender_id"], name: "index_waybills_on_sender_id"
    t.index ["storage_id"], name: "index_waybills_on_storage_id"
  end

  create_table "zones", force: :cascade do |t|
    t.string "code"
    t.string "kind"
    t.string "display_index"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_zones_on_code", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "batches", "production_units"
  add_foreign_key "batches", "storages"
  add_foreign_key "batches", "users", column: "loader_id"
  add_foreign_key "batches", "users", column: "machiner_id"
  add_foreign_key "batches", "users", column: "operator_id"
  add_foreign_key "batches", "users", column: "tester_id"
  add_foreign_key "box_packagings", "material_assets"
  add_foreign_key "box_packagings", "products"
  add_foreign_key "box_requests", "box_packagings"
  add_foreign_key "box_requests", "generations"
  add_foreign_key "boxes", "box_requests"
  add_foreign_key "boxes", "products"
  add_foreign_key "boxes", "regions"
  add_foreign_key "clients", "users", column: "manager_id"
  add_foreign_key "consolidations", "orders"
  add_foreign_key "consolidations", "plans"
  add_foreign_key "containers", "material_assets"
  add_foreign_key "containers", "packing_machines"
  add_foreign_key "cooked_semi_products", "cookings"
  add_foreign_key "cooked_semi_products", "semi_products"
  add_foreign_key "cookings", "batches"
  add_foreign_key "discounted_products", "products"
  add_foreign_key "discounted_products", "promotions"
  add_foreign_key "distributed_products", "distributions"
  add_foreign_key "distributed_products", "packaged_products"
  add_foreign_key "distributed_products", "regions"
  add_foreign_key "distributions", "batches"
  add_foreign_key "fields", "fields", column: "trackable_id"
  add_foreign_key "fields", "measurements"
  add_foreign_key "fields", "operations"
  add_foreign_key "fields", "standards"
  add_foreign_key "generation_downloads", "generations"
  add_foreign_key "generations", "distributed_products"
  add_foreign_key "groups", "categories"
  add_foreign_key "ingredients", "groups"
  add_foreign_key "ingredients", "material_assets"
  add_foreign_key "journals", "groups"
  add_foreign_key "leftovers", "leftovers", column: "parent_id"
  add_foreign_key "leftovers", "storages"
  add_foreign_key "leftovers", "waybills"
  add_foreign_key "material_assets", "categories"
  add_foreign_key "material_assets", "measurements"
  add_foreign_key "material_assets", "suppliers"
  add_foreign_key "metrics", "fields"
  add_foreign_key "metrics", "steps"
  add_foreign_key "operations", "journals"
  add_foreign_key "orders", "clients"
  add_foreign_key "orders", "sales_channels"
  add_foreign_key "orders", "sales_points"
  add_foreign_key "packaged_products", "packings"
  add_foreign_key "packaged_products", "products"
  add_foreign_key "packings", "batches"
  add_foreign_key "pallet_requests", "generations"
  add_foreign_key "pallets", "pallet_requests"
  add_foreign_key "participants", "clients"
  add_foreign_key "participants", "promotions"
  add_foreign_key "positions", "orders"
  add_foreign_key "positions", "products"
  add_foreign_key "positions", "promotions"
  add_foreign_key "prices", "products"
  add_foreign_key "prices", "sales_channels"
  add_foreign_key "production_units", "groups"
  add_foreign_key "production_units", "plans"
  add_foreign_key "products", "groups"
  add_foreign_key "products", "material_assets"
  add_foreign_key "products", "measurements"
  add_foreign_key "qr_scans", "boxes"
  add_foreign_key "qr_scans", "waybills", column: "groupable_id"
  add_foreign_key "route_sheets", "shipments"
  add_foreign_key "sales_points", "clients"
  add_foreign_key "sales_points", "regions"
  add_foreign_key "semi_ingredients", "groups"
  add_foreign_key "semi_ingredients", "semi_products"
  add_foreign_key "semi_products", "groups"
  add_foreign_key "semi_products", "measurements"
  add_foreign_key "sessions", "users"
  add_foreign_key "shipments", "clients"
  add_foreign_key "shipments", "plans"
  add_foreign_key "shipments", "regions"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "standards", "groups"
  add_foreign_key "standards", "measurements"
  add_foreign_key "steps", "batches"
  add_foreign_key "steps", "operations"
  add_foreign_key "suppliers", "users", column: "manager_id"
  add_foreign_key "supply_orders", "material_assets"
  add_foreign_key "tracking_products", "products"
  add_foreign_key "tracking_products", "route_sheets"
  add_foreign_key "warehousers", "storages"
  add_foreign_key "warehousers", "users"
  add_foreign_key "warehousers", "users", column: "replaceable_id"
  add_foreign_key "waybills", "batches"
  add_foreign_key "waybills", "storages"
  add_foreign_key "waybills", "storages", column: "new_storage_id"
  add_foreign_key "waybills", "users", column: "receiver_id"
  add_foreign_key "waybills", "users", column: "sender_id"
end
