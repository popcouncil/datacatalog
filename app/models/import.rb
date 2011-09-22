class Import
  def statsghana
    data = File.read(Rails.root + '/tmp/x.html')
    title = data.match(/<title>(.+)<\/title>/)[1]
    desc = data.match(/<div class="xsl-caption">Series Information<\/div>(.+?)<\/td>/m)[1].split
    #Africa - Ghana - 
    coverage = data.match(/Geographic Coverage \(1\)<\/div>(.+?)<\/td>/m)[1].strip
    year = #different link, non existent?
    tags = data.match(/Topics<\/div><ul style="margin-top:0px;padding-top:0px;"><li>(.+?)<\/ul>/m) #check taglist with some specific keywords, .include?
  end
end

=begin

Unable to find specific year of publication.
Tags don't match up, so the script will have to try to guess.


=end
