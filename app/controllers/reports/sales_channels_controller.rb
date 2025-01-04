class Reports::SalesChannelsController < ApplicationController
  def show
  end

  def create
    @channels = SalesChannel.ordered
    @products = products_scope
    @groups   = @products.map { |p| p.group }.uniq.sort_by(&:name)

    @sales_plans = sales_plans_scope
    @positions   = positions_scope

    @data = prepare_data @channels, @products, @sales_plans, @positions
  end

  private
    def products_scope
      base_scope = Product.ordered.includes(:group)
      if report_params[:group_id].present?
        base_scope = base_scope.filter_by_group(report_params[:group_id])
      end
      if report_params[:product_id].present?
        base_scope = base_scope.where(id: report_params[:product_id])
      end
      base_scope
    end

    def sales_plans_scope
      Estimation.filter_by_month *calculate_date_range
    end

    def positions_scope
      Position.filter_by_preferred_date *calculate_date_range
    end

    def calculate_date_range
      date = Date.new(
        report_params["range_period(1i)"].to_i,
        report_params["range_period(2i)"].to_i,
        report_params["range_period(3i)"].to_i
      )

      case report_params[:trunc_period]
      when "year"
        [ date.beginning_of_year, date.end_of_year ]
      else
        [ date.beginning_of_month, date.end_of_month ]
      end
    end

    def report_params
      params.expect(report: %i[ trunc_period range_period product_id product_id ])
    end

    def prepare_data(channels, products, estimations, positions)
      data = { groups: {}, products: {} }

      products.each do |product|
        product_data = initialize_product_data(data, product)
        group_data   = initialize_group_data(data, product)

        product_estimations = estimations.filter_by_product(product.id)
        product_positions   = positions.filter_by_product(product.id)

        channels.each do |channel|
          channel_data = prepare_channel_data(product, product_estimations, product_positions, channel)

          merge_channel_data(product_data, group_data, channel.id, channel_data)
          update_summary_data(product_data[:summary], group_data[:summary], channel_data)
        end

        calculate_deviations product_data[:summary]
      end

      calculate_group_deviations data[:groups]
      data
    end

    def initialize_product_data(data, product)
      data[:products][product.id] ||= { summary: {}, channels: {} }
    end

    def initialize_group_data(data, product)
      data[:groups][product.group_id] ||= { summary: {}, channels: {} }
    end

    def prepare_channel_data(product, product_estimations, product_positions, channel)
      plan_count = product_estimations.filter_by_sales_channel(channel.id).sum(:planned_count)
      plan_price = plan_count * product.price(by: channel.id).value
      plan_tonnage = product.tonnage(plan_count)

      fact_scope = product_positions.filter_by_sales_channel(channel.id)
      fact_count = fact_scope.sum(:count)
      fact_price = fact_scope.sum(:total_sum)
      fact_tonnage = product.tonnage(fact_count)

      deviation_absolute = fact_count - plan_count
      deviation_percent  = calculate_percentage deviation_absolute, plan_count

      {
        plan_count: plan_count,
        plan_price: plan_price,
        plan_tonnage: plan_tonnage,
        fact_count: fact_count,
        fact_price: fact_price,
        fact_tonnage: fact_tonnage,
        deviation_absolute: deviation_absolute,
        deviation_percent: deviation_percent
      }
    end

    def merge_channel_data(product_data, group_data, channel_id, channel_data)
      product_data[:channels][channel_id] ||= channel_data
      group_data[:channels][channel_id] ||= {
        plan_count: 0, plan_price: 0.0, plan_tonnage: 0.0,
        fact_count: 0, fact_price: 0.0, fact_tonnage: 0.0
      }

      group_data[:channels][channel_id].merge!(sum_channel_data(group_data[:channels][channel_id], channel_data))
    end

    def update_summary_data(product_summary, group_summary, channel_data)
      [ :plan_count, :plan_price, :plan_tonnage, :fact_count, :fact_price, :fact_tonnage ].each do |key|
        product_summary[key] ||= 0
        product_summary[key] += channel_data[key]

        group_summary[key] ||= 0
        group_summary[key] += channel_data[key]
      end
    end

    def sum_channel_data(group_channel, channel_data)
      group_channel.merge(channel_data) do |_, old_val, new_val|
        old_val + new_val
      end
    end

    def calculate_deviations(summary)
      plan_count = summary[:plan_count]
      deviation_absolute = summary[:fact_count] - plan_count
      deviation_percent = calculate_percentage(deviation_absolute, plan_count)

      summary[:deviation_absolute] = deviation_absolute
      summary[:deviation_percent] = deviation_percent
    end

    def calculate_group_deviations(groups)
      groups.each do |_, group_data|
        calculate_deviations(group_data[:summary])

        group_data[:channels].each do |_, channel_summary|
          calculate_deviations(channel_summary)
        end
      end
    end

    def calculate_percentage(deviation, plan_count)
      plan_count.zero? ? 0.0 : (deviation.to_d / plan_count.to_d) * 100.0
    end
end
