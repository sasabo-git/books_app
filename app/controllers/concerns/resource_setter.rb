# frozen_string_literal: true

module ResourceSetter
  extend ActiveSupport::Concern

  included do
    before_action :set_model
  end

  def set_resource
    instance_variable_set :"@#{model_name}", @model.find(params[:id])
  end

  def set_my_resource
    unless instance_variable_set :"@#{model_name}", @model.find_by(user_id: current_user.id, id: params[:id])
      redirect_to @model,  notice: t("notice.no_authority")
    end
  end

  private
    def set_model
      @model = controller_name.classify.constantize
    end

    def model_name
      controller_name.singularize
    end
end
