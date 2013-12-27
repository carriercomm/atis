class METAR::Node::Obstructions < METAR::Node::Base

  property :obstacle do
    case match[1]
      when "MT"
        :mountains
      else
        :masts
    end
  end

end