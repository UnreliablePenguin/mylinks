class CreateComments < ActiveRecord::Migration
  def up
      t.int :id
      t.string :link
      t.string :author
  end
end
