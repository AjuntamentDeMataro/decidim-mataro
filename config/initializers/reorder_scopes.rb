Decidim::Organization.class_eval do
  def scopes
    super.except(:order).order("id DESC")
  end
end
