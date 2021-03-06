# A form build that adheres to Bootstrap horizontal form conventions.
#
class BootstrapFormBuilder::HorizontalFormBuilder < ActionView::Helpers::FormBuilder
  def email_field(name, opts = {})
    form_group(name, opts.slice(:label_options, :group_options, :tip_options)) do
      super(name, opts.reverse_merge(:class => 'form-control',
                                     :autocorrect => 'off',
                                     :autocapitalize => 'off',
                                     :autocorrect => 'off',
                                     :spellcheck => 'off',
                                     :placeholder => help(name)).
                       reverse_merge(validation_attributes(name)))
    end
  end

  def text_field(name, opts = {})
    form_group(name, opts.slice(:label_options, :group_options, :tip_options)) do
      super(name, opts.reverse_merge(:class => 'form-control',
                                     :placeholder => help(name)).
                       reverse_merge(validation_attributes(name)))
    end
  end

  def search_field(name, opts = {})
    form_group(name, opts.slice(:label_options, :group_options, :tip_options)) do
      @template.content_tag(:div,
                  super(name, opts.reverse_merge(:class => 'form-control',
                                                 :placeholder => help(name)).
                                   reverse_merge(validation_attributes(name))) +
                  @template.content_tag(:span,
                                        @template.content_tag(:span, '', :class => 'glyphicon glyphicon-search'),
                                        :class => 'input-group-addon'),
                  :class => 'input-group')
    end
  end

  def password_field(name, opts = {})
    form_group(name, opts.slice(:label_options, :group_options, :tip_options)) do
      super(name, opts.reverse_merge(:class => 'form-control',
                                     :placeholder => help(name)).
                       reverse_merge(validation_attributes(name)))
    end
  end

  def date_field(name, opts = {})
    form_group(name, opts.slice(:label_options, :group_options, :tip_options)) do
      super(name, opts.reverse_merge(:class => 'form-control',
                                     :placeholder => help(name)).
                       reverse_merge(validation_attributes(name)))
    end
  end

  def number_field(name, opts = {})
    form_group(name, opts.slice(:label_options, :group_options, :tip_options)) do
      super(name, opts.reverse_merge(:class => 'form-control',
                                     :placeholder => help(name)).
                       reverse_merge(validation_attributes(name)))
    end
  end

  def check_box(name, opts = {})
    form_group(name, opts.slice(:label_options, :group_options, :tip_options)) do
      simple_check_box(name, opts)
    end
  end

  # A checkbox without the form group and control label
  def simple_check_box(name, options = {}, checked_value = '1', unchecked_value = '0')
    @template.content_tag(:div,
                          @template.content_tag(:label,
                                                @template.check_box(@object_name, name,
                                                                    objectify_options(options),
                                                                    checked_value,
                                                                    unchecked_value) +
                                                                    label_description(name).html_safe),
                          :class => 'checkbox', :data => validation_attributes(name))
  end

  # uses bootstrap option to stretch the buttons to the full enclosing width
  # if you use this, you may need to add the following style to your
  # stylesheet to re-hide the radio-button circle
  # (because Bootstrap's one is too specific to deal with this):
  #
  # [data-toggle="buttons"] .btn input[type="radio"] {
  #  position: absolute;
  #  z-index: -1;
  #  opacity: 0;
  #  filter: alpha(opacity=0);
  #}
  #
  def justified_radio_button_group(name, button_options, opts = {})
    form_group(name, opts.slice(:label_options, :group_options, :tip_options)) do
      buttons = button_options.map do |button|
        @template.content_tag(:div, radio_button_label(name, button), :class => 'btn-group')
      end.join("\n").html_safe

      @template.content_tag(:div,
                            buttons,
                            :class => 'btn-group btn-group-justified',
                            :data => { :toggle => 'buttons' })
    end
  end

  def radio_button_group(name, button_options, opts = {})
    form_group(name, opts.slice(:label_options, :group_options, :tip_options)) do
      buttons = button_options.map do |button|
        radio_button_label(name, button)
      end.join("\n").html_safe

      @template.content_tag(:div,
                            buttons,
                            :class => 'btn-group',
                            :data => { :toggle => 'buttons' }.
                              merge(validation_attributes(name)))
    end
  end

  def radio_button_label(name, button)
    label(name, :value => button, :class => 'btn btn-default') do
      radio_button(name, button) +
        I18n.t("#{object_name}.#{name}_options.#{button}",
               :scope => "helpers.label")
    end
  end

  def radio_group(name, button_options, opts = {})
    form_group(name, opts.slice(:label_options, :group_options, :tip_options)) do
      buttons = button_options.map do |button|
        radio_label(name, button)
      end.join("\n").html_safe

      @template.content_tag(:div,
                            buttons,
                            :class => 'radio-group',
                            :data => validation_attributes(name))
    end
  end

  def radio_label(name, button)
    label = label("#{name}_#{button}", :class => 'radio-label') do
      radio_button(name, button) +
        I18n.t("#{object_name}.#{name}_options.#{button}",
               :scope => "helpers.label")
    end

    @template.content_tag(:div,
                            label,
                            :class => 'radio')
  end

  def select(name, choices, options = {}, html_options = {})
    form_group(name, options.slice(:label_options, :group_options, :tip_options)) do
      super(name, choices, options,
            html_options.reverse_merge(:class => 'form-control').
                         reverse_merge(validation_attributes(name)))
    end
  end

  def text_area(name, opts = {})
    form_group(name, opts.slice(:label_options, :group_options, :tip_options)) do
      super(name, opts.reverse_merge(:class => 'form-control',
                                     :placeholder => help(name)).
                       reverse_merge(validation_attributes(name)))
    end
  end

  def form_group(name, options = {}, &block)
    group_options = options.fetch(:group_options, {})
    classes = Array(group_options[:class]) << 'form-group'

    if @object.errors.has_key?(name)
      classes << 'has-error'
    end

    @template.content_tag(:div,
                          label(name, options.fetch(:label_options, {})) +
                          col_wrap(block.call + errors(name)) +
                          tip(name, options.fetch(:tip_options, {})),
                          group_options.merge(:class => classes.join(' ')))
  end

  def col_wrap(html)
    @template.content_tag(:div, html, :class => 'field')
  end

  def label(name, opts = {})
    classes = Array(opts.fetch(:class, nil))
    classes << 'control-label' if classes.empty?
    super(name, opts.merge(:class => classes.join(' ')))
  end

  def errors(name)
    if @object.errors.has_key?(name)
      errors = @object.errors.full_messages_for(name).join('. ')
      @template.content_tag(:span, errors, :class => 'help-text text-danger')
    else
      ''
    end
  end

  def help(name)
    i18n_name = "helpers.hints.#{object_name}.#{name}"
    if I18n.exists?(i18n_name)
      I18n.t(i18n_name)
    else
      nil
    end
  end

  def label_description(name)
    # use description if provided, default to the label-text
    desc = I18n.t("helpers.label.#{object_name}.#{name}_description", :default => "")
    return desc if desc.present?
    I18n.t("helpers.label.#{object_name}.#{name}", :default => "")
  end

  def tip(name, options = {})
    i18n_name = "helpers.tips.#{object_name}.#{name}"
    if I18n.exists?(i18n_name)
      options[:class] = (Array(options[:class]) + ['help-block']).join(' ')
      @template.content_tag(:span, I18n.t(i18n_name), options)
    end
  end

  def cancel_button(cancel_path)
    @template.link_to(I18n.t('helpers.button.cancel'),
                      cancel_path,
                      :class => 'btn btn-default')
  end

  def submit_button(label = "", opts = {})
    @template.content_tag(:div,
                          @template.
                            content_tag(:div,
                                        submit(label, opts.reverse_merge(:class => 'btn btn-primary')),
                                        :class => 'button-group'),
                          :class => 'form-group')
  end

  def submit_and_cancel(cancel_path)
    @template.content_tag(:div,
                          @template.
                            content_tag(:div,
                                        submit(:class => 'btn btn-primary') +
                                        " " + cancel_button(cancel_path),
                                        :class => 'button-group'),
                          :class => 'form-group')
  end

  def validation_attribute_map
    {
      ActiveModel::Validations::PresenceValidator => proc { { :required => true } },
      ActiveModel::Validations::InclusionValidator => proc {|validator|
        # Inclusion is weird, in Rails if you have a radio button
        # where you want one of the options selected, and they map
        # to a boolean then using :presence doesn't work, because
        # the presence check on false fails. Instead you have to use
        # inclusion, so we can handle this here and map it to required
        # validation attribute, this is kinda getting a bit hacky though,
        # and may come back to bite us in the foot, so we limit the use
        # to only those cases where true and false are the only options.
        if validator.options[:in] == [true,false]
          { :required => true }
        else
          { }
        end
      },
      ActiveModel::Validations::FormatValidator => proc {|validator|
        flasg, regex = nil, validator.options[:with].inspect.strip[1..-1] # kill leading slash
        # flags (eg i) after trailing slash
        regex,flags = regex.split('/') if regex.last != "/" 

        # Because RegExp#to_s is weird we use inspect, but strip first and last /
        opts = {:'data-pattern' => regex,
                :'data-pattern-message' => validator.options[:message] }
        opts[:'data-pattern-flags'] = flags if flags.present?
        opts
      }
    }
  end


  def validation_attributes(name)
    return {} unless options[:validations]
    return {} unless object.respond_to?(:_validators)

    validators = object._validators.fetch(name, [])

    validators.reduce({}) do |attributes, validator|
      attributes.merge(validation_attribute_map.fetch(validator.class, proc {}).call(validator))
    end
  end
end
