ActiveAdmin.register Kendocup::TeamCategory do

  permit_params :name, :pool_size, :out_of_pool, :min_age, :max_age, :description_en, :description_fr, :cup_id

  index do
    column :name
    column :teams_count, sortable: false do |team_category|
      team_category.teams.count
    end
    column :created_at
    column :updated_at
    actions
  end

  show do |category|
    attributes_table do
      row :name
      row :description
      row :pool_size
      row :out_of_pool
    end
    if category.teams.present?
      panel "Teams" do
        table do
          thead do
            tr do
              th do
                "Name"
              end
              th do
                "Kenshis"
              end
            end
          end
          tbody do
            category.teams.order(:name).each do |team|
              tr do
                td do
                  "Team “#{team.name}”"
                end
                td do
                  team.kenshis.map do |k|
                    link_to k.poster_name, [:admin, k]
                  end.join(", ").html_safe
                end
              end
            end
          end
        end
      end
    end
  end

  member_action :pdf do
    @team_category = TeamCategory.find params[:id]
    pdf = TeamCategoryPdf.new(@team_category)
    send_data pdf.render, filename: @team_category.name.parameterize('_'),
                          type: "application/pdf",
                          disposition: "inline",
                          page_size: 'A4'

  end
  action_item only: :show do
    link_to "PDF", pdf_admin_team_kendocup_category_path(team_category)
  end

  # collection_action :pdfs do
  #   @team_categories = TeamCategory.order(:name)
  #   pdf = TeamCategoryPdf.new(@team_categories)
  #   send_data pdf.render, filename: "team_categories",
  #                         type: "application/pdf",
  #                         disposition: "inline",
  #                         page_size: 'A4'
  # end
  # action_item only: :index do
  #   link_to("PDF", pdfs_admin_team_categories_path)
  # end

  collection_action :team_match_sheet do
    pdf = TeamCategoryMatchSheetPdf.new
    send_data pdf.render, filename: "team_categories",
                          type: "application/pdf",
                          disposition: "inline",
                          page_size: 'A4'
  end
  action_item do
    link_to("Match sheet", team_match_sheet_admin_kendocup_team_categories_path)
  end
end