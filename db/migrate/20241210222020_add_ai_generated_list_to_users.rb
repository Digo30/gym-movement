class AddAiGeneratedListToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :ai_generated_list, :text
  end
end
