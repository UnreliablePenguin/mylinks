class CreateVideos < ActiveRecord::Migration
  def up
      t.string :id
      t.string :comment
      t.string :author
      t.int :video_id
  end
end
