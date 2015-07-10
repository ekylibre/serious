module ParticipantsHelper

  # Show a participant card with logo and minimal infos
  def participant_card(participant, options = {}, &block)
    options[:content] = capture(participant, &block) if block_given?
    render "participants/card", participant: participant, content: options.delete(:content), options: options
  end

  # Show a participant logo
  def participant_logo(participant)
    if participant.logo.file?
      return image_tag(participant.logo.url(:identity))
    else
      return content_tag(:div, participant.abbreviation, class: "participant-abbreviation", style: "background-color: ##{participant.color}")
    end
  end

  def items_block(participant, reflection, options = {})
    collection = participant.send(reflection)
    if options[:relative_to] and options[:relative_to] != participant
      unless options[:as]
        raise "Options :as is needed for #{reflection}"
      end
      collection = collection.where(options[:as] => options[:relative_to])
    end
    if collection.any?
      html = render "participants/items_block", reflection: reflection, collection: collection, item_partial: "item_#{reflection.to_s.singularize}"
      return html if options[:wrap].is_a? FalseClass
      if options[:wrap].is_a?(Hash)
        return content_tag(:div, html, options[:wrap])
      else
        return content_tag(:div, html, class: "col-md-6")
      end
    end
  end

end
