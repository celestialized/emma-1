class Blog::Entry < ApplicationRecord
  # tag entries
  acts_as_taggable_on :tags
  acts_as_taggable_on :skills, :interests #You can also configure multiple tag types per model
  
  # connect to blog_articles
  scope :featured, -> { where("pinned_value > ?", 0)
                        .order(pinned_value: :desc)
                        .first(3)}

  scope :featured_2nd_and_3rd, -> { where("pinned_value > ?", 0)
                        .order(pinned_value: :desc)
                        .first(3).last(2)}

  scope :featured_on_aside, -> {  where("pinned_value > ?", 0)
                                  .order(pinned_value: :desc)
                                  .first(5).last(2)}

  scope :published, -> {  where("publish_at is not ?", nil)
                          .where("publish_at < ?", Time.now)}

  has_rich_text :summary

  has_one   :article, 
            foreign_key: "entry_id", 
            class_name: "Blog::Article"#,
            # inverse_of: :entry                     

  # connect to blog_video_embeds  
  has_many            :blog_video_embeds
  has_one_attached    :image # hero image for entry
  
  # connect to blog_recommendations
  has_many  :recommendations, 
            foreign_key: "entry_id", 
            class_name: "Blog::Recommendation"#,
            # inverse_of: :entry
  accepts_nested_attributes_for :recommendations, 
                                reject_if: :all_blank, 
                                allow_destroy: true

  #connect to recommended_entries
  has_many  :recommended_entries, 
            :through => :recommendations,                 
            :source => :recommended_entry                      



  extend FriendlyId
  friendly_id :title, use: :slugged

  def self.all_pinned
    Blog::Entry.where("pinned_value > ?", 0)
    # "helow"
  end

  def self.from_time
    Time.now - self.created_at
  end
end
