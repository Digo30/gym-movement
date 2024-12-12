class AddContentAndCreatedAtToTrainings < ActiveRecord::Migration[7.0]
  def change
    # Adiciona a coluna 'content' somente se ela não existir
    unless column_exists?(:trainings, :content)
      add_column :trainings, :content, :text
    end

    # Adiciona a coluna 'created_at' somente se ela não existir
    unless column_exists?(:trainings, :created_at)
      add_column :trainings, :created_at, :datetime
    end
  end
end
