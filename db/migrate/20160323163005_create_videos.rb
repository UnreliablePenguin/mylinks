class CreateVideos < ActiveRecord::Migration
  def up
    create_table :videos do |t|
      t.string :link 
      t.string :author
    end
    create_table :comments do |t|
      t.string :author
      t.string :comment
      t.integer :points
    end
    add_reference :comments, :videos
  end

  def down
    drop_table :videos
    drop_table :comments
  end
end
