module Fifo
  extend ActiveSupport::Concern

  included do
    scope :filter_by_ids, ->(ids) { where(id: ids) }
    scope :calculated_fifo_for, ->(product_id, count, unrestricted_count, filtered_ids, filtered_date = "") do
      query = <<-SQL
      WITH FilteredBoxes AS (
          SELECT *
          FROM boxes
          WHERE product_id = :product_id#{' '}
          AND id IN (:filtered_ids)
          AND production_date > TO_DATE(:filtered_date, 'YYYY-MM-DD')
      ),
      FIFO_Boxes AS (
          SELECT *, SUM(capacity) OVER (PARTITION BY product_id ORDER BY production_date, id) AS cumulative_capacity
          FROM FilteredBoxes
      ),
      SelectedFIFO AS (
          SELECT *
          FROM FIFO_Boxes
          WHERE cumulative_capacity - capacity < :count - :unrestricted_count
      ),
      UnrestrictedBoxes AS (
          SELECT *, SUM(capacity) OVER (PARTITION BY product_id, production_date ORDER BY id) AS cumulative_capacity_within_date
          FROM FilteredBoxes
          WHERE id NOT IN (SELECT id FROM SelectedFIFO)
      ),
      SelectedUnrestricted AS (
          SELECT *
          FROM UnrestrictedBoxes
          WHERE cumulative_capacity_within_date - capacity < :unrestricted_count
      )
      SELECT id, code, region_id, product_id, capacity, production_date, expiration_date, box_request_id, created_at, updated_at, taken_out_at
      FROM SelectedFIFO

      UNION ALL

      SELECT id, code, region_id, product_id, capacity, production_date, expiration_date, box_request_id, created_at, updated_at, taken_out_at
      FROM SelectedUnrestricted
      ORDER BY production_date, id, capacity
      SQL

      filter_by_ids find_by_sql([ query, { product_id:, count:, unrestricted_count:, filtered_ids:, filtered_date: } ]).map(&:id)
    end

    scope :calculated_strict_fifo_for, ->(product_id, count, unrestricted_count, filtered_ids, filtered_date = "") do
      query = <<-SQL
      WITH FilteredBoxes AS (
          SELECT *
          FROM boxes
          WHERE product_id = :product_id#{' '}
          AND id IN (:filtered_ids)
          AND production_date > TO_DATE(:filtered_date, 'YYYY-MM-DD')
      ),
      FIFO_Boxes AS (
          SELECT *, SUM(capacity) OVER (PARTITION BY product_id ORDER BY production_date, id) AS cumulative_capacity
          FROM FilteredBoxes
      ),
      SelectedFIFO AS (
          SELECT *
          FROM FIFO_Boxes
          WHERE cumulative_capacity - capacity < :count - :unrestricted_count
      )
      SELECT id, code, region_id, product_id, capacity, production_date, expiration_date, box_request_id, created_at, updated_at, taken_out_at
      FROM SelectedFIFO
      ORDER BY production_date, id, capacity
      SQL

      filter_by_ids find_by_sql([ query, { product_id:, count:, unrestricted_count:, filtered_ids:, filtered_date: } ]).map(&:id)
    end

    scope :calculated_bypass_fifo_for, ->(product_id, count, unrestricted_count, filtered_ids, filtered_date = "") do
      query = <<-SQL
      WITH FilteredBoxes AS (
          SELECT *
          FROM boxes
          WHERE product_id = :product_id#{' '}
          AND id IN (:filtered_ids)
          AND production_date > TO_DATE(:filtered_date, 'YYYY-MM-DD')
      ),
      FIFO_Boxes AS (
          SELECT *, SUM(capacity) OVER (PARTITION BY product_id ORDER BY production_date, id) AS cumulative_capacity
          FROM FilteredBoxes
      ),
      SelectedFIFO AS (
          SELECT *
          FROM FIFO_Boxes
          WHERE cumulative_capacity - capacity < :count - :unrestricted_count
      ),
      UnrestrictedBoxes AS (
          SELECT *, SUM(capacity) OVER (PARTITION BY product_id, production_date ORDER BY id) AS cumulative_capacity_within_date
          FROM FilteredBoxes
          WHERE id NOT IN (SELECT id FROM SelectedFIFO)
      ),
      SelectedUnrestricted AS (
          SELECT *
          FROM UnrestrictedBoxes
          WHERE cumulative_capacity_within_date - capacity < :unrestricted_count
      )
      SELECT id, code, region_id, product_id, capacity, production_date, expiration_date, box_request_id, created_at, updated_at, taken_out_at
      FROM SelectedUnrestricted
      ORDER BY production_date, id, capacity
      SQL

      filter_by_ids find_by_sql([ query, { product_id:, count:, unrestricted_count:, filtered_ids:, filtered_date: } ]).map(&:id)
    end
  end
end
