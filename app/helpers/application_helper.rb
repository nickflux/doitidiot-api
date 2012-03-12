module ApplicationHelper

  # replace swears
  def swear_generator(text)
    return if text.blank?
    # swear nouns
    @diswnouns  = Rails.cache.fetch("diswnouns") do
      Redact.where(:code_name => 'diswnouns').first.redact_array 
    end
    text.gsub!('#diswnoun#', @diswnouns.sample)

    # simple swear nouns
    @diswnouns_simp = Rails.cache.fetch("diswnouns_simp") do
      Redact.where(:code_name => 'diswnouns-simp').first.redact_array 
    end
    text.gsub!('#diswnoun-simp#', @diswnouns_simp.sample)
    
    # swear adjectives
    @diswadjs = Rails.cache.fetch("diswadjs") do
      Redact.where(:code_name => 'diswadjs').first.redact_array 
    end
    text.gsub!('#diswadj#', @diswadjs.sample)
    
    # simple swear adjectives
    @diswadjs_simp  = Rails.cache.fetch("diswadjs_simp") do
      Redact.where(:code_name => 'diswadjs-simp').first.redact_array 
    end 
    text.gsub!('#diswadj-simp#', @diswadjs_simp.sample)
    
    # image replacement
    text.gsub! /#diswimage(.)+#/ do |image_text|
      diswimage(image_text)
    end
    
    return text
  end
  
  # display text using Textile
  def textilize(text)  
    text  = swear_generator(text)
    RedCloth.new(text).to_html.html_safe unless text.blank?  
  end
  
  # generate random image tag
  # e.g., #diswimage:boggle:png:5:300#
  # for boggle-(n).png, n = 1 - 5, height: 300px
  # options: [0] => title, [1] => file extension, [2] => number of options, [3] => width in pixels
  def diswimage(image_text)
    image_options   = image_text.gsub(/#/, '').gsub(/diswimage:/, '').split(':')
    image_title     = image_options[0]
    image_extension = image_options[1]
    option_count    = image_options[2]
    image_width     = image_options[3]
    return "!{width: #{image_width}px}http://doitidiot.s3.amazonaws.com/#{image_title}-#{rand(option_count)+1}.#{image_extension}!"
  end
  

  # redact certain blacklisted words
  def redactor(text)
    @blacklist  = Rails.cache.fetch("blacklist") do
      Redact.where(:code_name => 'blacklist').first.redact_array 
    end
    @blacklist.each do |b|
      text  = text.gsub(Regexp.new(b, true), "[REDACTED]")
    end
    @emoticons  = Rails.cache.fetch("emoticons") do
      Redact.where(:code_name => 'emoticons').first.redact_array 
    end
    @emoticons.each do |e|
      text  = text.gsub(e, ":(")
    end
    return text
  end

end
