# frozen_string_literal: true
require "sidekiq/web"

Rails.application.routes.draw do
  get "processes/:process_slug", to: redirect { |params, _request|
    process = Decidim::ParticipatoryProcess.find_by_slug(params[:process_slug])
    "/processes/#{process.id}"
  }, constraints: { process_slug: /[^0-9]+/ }

  feature_translations = {
    action_plans: [:results, Decidim::Results::Result],
    meetings: [:meetings, Decidim::Meetings::Meeting],
    proposals: [:proposals, Decidim::Proposals::Proposal],
    debates: [:debates, Decidim::Debates::Debate]
  }

  constraints host: "www.decidimmataro.cat" do
    get "/:process_slug/:step_id/:feature_name/(:resource_id)", to: redirect { |params, _request|
      process = Decidim::ParticipatoryProcess.find_by_slug(params[:process_slug]) || Decidim::ParticipatoryProcess.find(params[:process_slug])

      feature_translation = feature_translations[params[:feature_name].to_sym]
      feature_manifest_name = feature_translation[0]

      feature = Decidim::Feature.find_by(
        manifest_name: feature_manifest_name,
        participatory_process: process
      )

      if params[:resource_id]
        resource_class = feature_translation[1]
        resource = resource_class.where("extra->>'slug' = ?", params[:resource_id]).first || resource_class.find(params[:resource_id])

        "/processes/#{process.id}/f/#{feature.id}/#{feature_manifest_name}/#{resource.id}"
      else
        "/processes/#{process.id}/f/#{feature.id}"
      end
    }, constraints: { process_id: /[^0-9]+/, step_id: /[0-9]+/, feature_name: Regexp.new(feature_translations.keys.join("|")) }

    get "/:feature_name/:resource_id", to: redirect { |params, _request|
      feature_translation = feature_translations[params[:feature_name].to_sym]
      resource_class = feature_translation[1]
      resource = resource_class.where("extra->>'slug' = ?", params[:resource_id]).first || resource_class.find(params[:resource_id])
      feature = resource.feature
      process = feature.participatory_process
      feature_manifest_name = feature.manifest_name
      "/processes/#{process.id}/f/#{feature.id}/#{feature_manifest_name}/#{resource.id}"
    }, constraints: { feature_name: Regexp.new(feature_translations.keys.join("|")) }
  end

  authenticate :user, lambda { |u| u.roles.include?("admin") } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount Decidim::Core::Engine => "/"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
