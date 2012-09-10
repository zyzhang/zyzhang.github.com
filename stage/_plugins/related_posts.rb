require 'jekyll/post'

## refer to https://github.com/LawrenceWoodman/related_posts-jekyll_plugin
## calculate the correlation by tags and categories

module RelatedPosts

  # Used to remove #related_posts so that it can be overridden
  def self.included(klass)
    klass.class_eval do
      remove_method :related_posts
    end
  end

  # Calculate related posts.
  #
  # Returns [<Post>]
  def related_posts(posts)
    return [] unless posts.size > 1
    
    related_scores = Hash.new(0)
    posts.each do |post|
    	if post != self
      	 	related_scores[post] = 0
      	 	
    		post.tags.each do |tag| 
    			if self.tags.include?(tag)
    	  			related_scores[post] += 2
    	  		end	    
    		end
    		
    	end
    end

    Jekyll::Post.sort_related_posts(related_scores)
    
  end

  module ClassMethods
    # Sort the related posts in order of their score and date
    # and return just the posts
    def sort_related_posts(related_scores)
      related_scores.sort do |a,b|
        if a[1] < b[1]
          1
        elsif a[1] > b[1]
          -1
        else
          b[0].date <=> a[0].date
        end
      end.collect {|post,freq| post}
    end
  end

end

module Jekyll
  class Post
    include RelatedPosts
    extend RelatedPosts::ClassMethods
  end
end