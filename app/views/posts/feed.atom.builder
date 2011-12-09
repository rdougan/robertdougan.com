atom_feed :language => 'en-US' do |feed|
  feed.title "Robert Dougan"
  feed.updated Time.now

  @posts.each do |post|
    feed.entry(post, :url => "/posts/#{post.permalink}") do |entry|
      entry.title post.name
      entry.content markdown(post.body), :type => 'html'
      entry.updated(post.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 
      entry.published(post.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 

      entry.author do |author|
        author.name "Robert Dougan"
      end
    end
  end
end