# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  protected
    def after_update_path_for(resource)
      user_path(id: current_user.id)
    end

    def update_resource(resource, params)
      resource.update_without_password(params)
    end
end
