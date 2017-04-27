Paperclip.options[:content_type_mappings] = { xls: 'application/vnd.ms-excel' }

module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end