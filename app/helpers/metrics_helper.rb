module MetricsHelper
  def metric_plan_tag(metric)
    if metric.field.normal?
      t("forms.standard", from: metric.field.standard.from, to: metric.field.standard.to)
    end
  end

  def metric_fact_tag(metric)
    return default_tag t("forms.no_data") unless metric.value?

    if metric.field.date?
      time_tag metric.value.to_date
    elsif metric.field.time?
      default_tag metric.value
    elsif metric.field.binary?
      binary_tag metric.value
    elsif metric.field.measure?
      measure_tag metric
    elsif metric.field.normal?
      normal_tag metric
    elsif metric.field.collection?
      collection_tag metric
    end
  end

  def metric_label_tag(form)
    form.label :value, form.object.display_label, class: "form-label-xl"
  end

  def metric_input_tag(form)
    metric = form.object

    if metric.field.date?
      form.date_field :value, required: true, class: default_input_class
    elsif metric.field.time?
      form.time_field :value, required: true, class: default_input_class
    elsif metric.field.binary?
      binary_input form
    elsif metric.field.measure?
      measure_input form
    elsif metric.field.normal?
      normal_input form
    elsif metric.field.collection?
      collection_input form
    end
  end

  private
    def binary_tag(value)
      value == "true" ? t("forms.binary_yes") : t("forms.binary_no")
    end

    def measure_tag(metric)
      t("forms.measurement", value: metric.value, unit: metric.field.measurement.unit)
    end

    def normal_tag(metric)
      passed = metric.field.standard.passed?(metric.value.to_i)
      default_tag metric.value, class_name: passed ? "text-green-600" : "text-red-600"
    end

    def collection_tag(metric)
      if metric.field.packing_machine?
        PackingMachine.where(id: metric.value).first&.name
      end
    end

    def default_tag(text, class_name: "")
      tag.span text, class: class_name
    end

    def binary_input(form)
      tag.div class: "space-y-6 sm:flex sm:items-center sm:space-x-6 sm:space-y-0" do
        yes = tag.div class: "flex items-center" do
          concat form.radio_button :value, true, class: "metric-radio-btn"
          concat label_tag "metric_value_true", t("forms.binary_yes"), class: "metric-radio-label"
        end
        no = tag.div class: "flex items-center" do
          concat form.radio_button :value, false, class: "metric-radio-btn"
          concat label_tag "metric_value_false", t("forms.binary_no"), class: "metric-radio-label"
        end
        yes + no
      end
    end

    def measure_input(form)
      tag.div do
        concat form.number_field :value, required: true, class: default_input_class, step: ".1"
        concat tag.p t("forms.measurement_detail", unit: form.object.field.measurement.unit), class: "mt-2 text-sm text-gray-500"
      end
    end

    def normal_input(form)
      tag.div do
        concat form.number_field :value, required: true, class: default_input_class, step: ".1"
        concat tag.p t("forms.standard", from: form.object.field.standard.from, to: form.object.field.standard.to), class: "mt-2 text-sm text-gray-500"
      end
    end

    def collection_input(form)
      if form.object.field.packing_machine?
        form.select :value, options_from_collection_for_select(PackingMachine.all, :id, :name, form.object.value), { include_blank: true }, { required: true, class: "mt-2 form-select-xl" }
      end
    end

    def default_input_class
      "mt-2 form-input-xl"
    end
end
