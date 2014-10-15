module Stages
  class UpdateStage < Mutations::Command
    required do
      string :id
      model :user
      model :stage
    end

    optional do
      string :name
      string :days_start
      string :instructions
      string :days_end
    end

    def validate
      validate_permissions
    end

    def execute
      set_valid_params
      stage
    end

    def validate_permissions
      if stage.guide.user != user
        msg = 'You can only update stages that belong to your guides.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end

    def set_valid_params
      # TODO: Probably a DRYer way of doing this.
      stage.instructions   = instructions if instructions.present?
      stage.days_start     = days_start if days_start.present?
      stage.days_end       = days_end if days_end.present?
      stage.name           = name if name.present?

      stage.save
    end
  end
end
