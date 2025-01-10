class SalesChannel < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :prices, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :estimations, dependent: :destroy

  scope :ordered, -> { order(name: :asc) }

  scope :report_for_plan_fact, ->(date) do
    start_of_current_month, end_of_current_month = date.beginning_of_month, date.end_of_month
    start_of_current_year, end_of_current_year = date.beginning_of_year, date.end_of_year

    start_of_prev_month, end_of_prev_month = date.prev_month.beginning_of_month, date.prev_month.end_of_month
    start_of_prev_year, end_of_prev_year = date.prev_year.beginning_of_year, date.prev_year.end_of_year

    with(
      previous_month_orders: Arel.sql(<<~SQL
          SELECT o.sales_channel_id, COALESCE(SUM(p.total_sum), 0) AS previous_fact_total_sum
          FROM orders o
          JOIN positions p ON o.id = p.order_id
          WHERE o.status = 'completed' AND o.preferred_date BETWEEN '#{start_of_prev_month}' AND '#{end_of_prev_month}'
          GROUP BY o.sales_channel_id
        SQL
      ),
      current_month_estimation: Arel.sql(<<~SQL
          SELECT e.sales_channel_id, COALESCE(SUM(e.planned_count * COALESCE(p.value, 0)), 0) AS current_plan
          FROM estimations e
          JOIN sales_plans sp ON e.sales_plan_id = sp.id
          LEFT JOIN prices p ON e.product_id = p.product_id
          AND e.sales_channel_id = p.sales_channel_id AND p.active = TRUE
          WHERE sp.month BETWEEN '#{start_of_current_month}' AND '#{end_of_current_month}'
          GROUP BY e.sales_channel_id
        SQL
      ),
      current_month_orders: Arel.sql(<<~SQL
          SELECT o.sales_channel_id, COALESCE(SUM(p.total_sum), 0) AS fact_total_sum
          FROM orders o
          JOIN positions p ON o.id = p.order_id
          WHERE o.status = 'completed' AND o.preferred_date BETWEEN '#{start_of_current_month}' AND '#{end_of_current_month}'
          GROUP BY o.sales_channel_id
        SQL
      ),
      current_month_returns: Arel.sql(<<~SQL
          SELECT
            o.sales_channel_id,
            COALESCE(SUM((rp.count * pr.packing) / NULLIF(m.tonne_ratio, 0)), 0) AS return_total_tonnage,
		        COALESCE(SUM(rp.count * p.total_sum / p.count), 0) AS return_total_sum
	        FROM returns r
			    JOIN returned_products rp ON r.id = rp.return_id
			    JOIN orders o ON r.order_id = o.id
			    JOIN positions p ON rp.product_id = p.product_id AND o.id = p.order_id
			    JOIN products pr ON rp.product_id = pr.id
			    LEFT JOIN measurements m ON pr.measurement_id = m.id
		      WHERE r.status = 'approved' AND o.preferred_date BETWEEN '#{start_of_current_month}' AND '#{end_of_current_month}'
		      GROUP BY o.sales_channel_id
        SQL
      ),
      current_year_orders: Arel.sql(<<~SQL
          SELECT o.sales_channel_id, COALESCE(SUM((p.count * pr.packing) / NULLIF(m.tonne_ratio, 0)), 0) AS current_year_total_tonnage
	        FROM orders o
		      JOIN positions p ON o.id = p.order_id
		      LEFT JOIN products pr ON p.product_id = pr.id
		      LEFT JOIN measurements m ON pr.measurement_id = m.id
	        WHERE o.status = 'completed' AND o.preferred_date BETWEEN '#{start_of_current_year}' AND '#{end_of_current_year}'
	        GROUP BY o.sales_channel_id
        SQL
      ),
      previous_year_orders: Arel.sql(<<~SQL
          SELECT o.sales_channel_id, COALESCE(SUM((p.count * pr.packing) / NULLIF(m.tonne_ratio, 0)), 0) AS previous_year_total_tonnage
	        FROM orders o
		      JOIN positions p ON o.id = p.order_id
		      LEFT JOIN products pr ON p.product_id = pr.id
		      LEFT JOIN measurements m ON pr.measurement_id = m.id
	        WHERE o.status = 'completed' AND o.preferred_date BETWEEN '#{start_of_prev_year}' AND '#{end_of_prev_year}'
	        GROUP BY o.sales_channel_id
        SQL
      )
    ).select(<<~SQL
        sales_channels.id,
        sales_channels.name,
        COALESCE(pmo.previous_fact_total_sum, 0) AS previous_fact_total_sum,
	      COALESCE(cme.current_plan, 0) AS plan_total_sum,
	      COALESCE(cmo.fact_total_sum, 0) AS fact_total_sum,
	      COALESCE(
		    CASE WHEN COALESCE(cme.current_plan, 0) > 0 THEN
			      ROUND((cmo.fact_total_sum / cme.current_plan) * 100, 2)
	      ELSE
		        0
		    END, 0) AS fact_to_plan_percent,
	      COALESCE(
		    CASE WHEN COALESCE(cmo.fact_total_sum, 0) > 0 THEN
			      ROUND((cme.current_plan / cmo.fact_total_sum) * 100, 2)
	      ELSE
		        0
		    END, 0) AS plan_to_fact_percent,
	      COALESCE(
		    CASE WHEN COALESCE(cmo.fact_total_sum, 0) > 0 THEN
			      ROUND((cmo.fact_total_sum / pmo.previous_fact_total_sum) * 100, 2)
	      ELSE
		        0
		    END, 0) AS fact_to_fact_percent,
	      COALESCE(cmr.return_total_sum, 0) AS return_total_sum,
	      COALESCE(
		    CASE WHEN COALESCE(cmo.fact_total_sum, 0) > 0 THEN
			      ROUND((cmr.return_total_sum / cmo.fact_total_sum) * 100, 2)
	      ELSE
		        0
		    END, 0) AS return_total_sum_percent,
	      COALESCE(cmr.return_total_tonnage, 0) AS return_total_tonnage,
        COALESCE(
          CASE WHEN COALESCE(cmr.return_total_tonnage, 0) > 0 THEN
            ROUND((cmr.return_total_tonnage / cyo.current_year_total_tonnage) * 100, 2)
        ELSE
          0
        END, 0) AS return_total_tonnage_percent,
        COALESCE(cyo.current_year_total_tonnage, 0) AS current_year_total_tonnage,
        COALESCE(pyo.previous_year_total_tonnage, 0) AS previous_year_total_tonnage,
        COALESCE(
          CASE WHEN COALESCE(cyo.current_year_total_tonnage, 0) > 0 THEN
            ROUND((cyo.current_year_total_tonnage / pyo.previous_year_total_tonnage) * 100, 2)
        ELSE
          0
        END, 0) AS year_fact_to_fact_percent
    SQL
    ).joins(<<~SQL
        LEFT JOIN current_month_estimation cme ON sales_channels.id = cme.sales_channel_id
	      LEFT JOIN current_month_orders cmo ON sales_channels.id = cmo.sales_channel_id
	      LEFT JOIN previous_month_orders pmo ON sales_channels.id = pmo.sales_channel_id
	      LEFT JOIN current_month_returns cmr ON sales_channels.id = cmr.sales_channel_id
	      LEFT JOIN current_year_orders cyo ON sales_channels.id = cyo.sales_channel_id
	      LEFT JOIN previous_year_orders pyo ON sales_channels.id = pyo.sales_channel_id
    SQL
    )
  end
end
