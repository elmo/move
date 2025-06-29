module Admin
  class ProvidersController < AdminController
    def index
      @providers = Provider.all.order(created_at: :desc)
      @pagy, @providers = pagy(@providers, items: 20)
    end

    def show
      @provider = Provider.find_by(slug: params[:id])
    end

    def approve
      @provider = Provider.find_by(slug: params[:id])
      @provider.approve!
      redirect_to admin_provider_path(@provider), notice: "Provider approved"
    end

    def reject
      @provider = Provider.find_by(slug: params[:id])
      @provider.reject!
      redirect_to admin_provider_path(@provider), notice: "Provider rejected"
    end
  end
end
