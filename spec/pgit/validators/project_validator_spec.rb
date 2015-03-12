require 'pgit'

describe 'PGit::Validators::ProjectValidator' do
  describe '#valid?' do
    it 'should not be valid when the request for stories fails' do
      class SomeFakeProjectWithKindError
        include ActiveModel::Validations
        validates_with PGit::Validators::ProjectValidator
        def get!
        end

        def kind
          'error'
        end
      end
      project = SomeFakeProjectWithKindError.new
      validator = PGit::Validators::ProjectValidator.new
      validator.validate(project)

      expect(project).not_to be_valid
    end

    it 'should not be valid if the project does not have a kind' do
      class SomeFakeProjectWithNoKind
        include ActiveModel::Validations
        validates_with PGit::Validators::ProjectValidator

        def get!
        end
      end

      project = SomeFakeProjectWithNoKind.new
      validator = PGit::Validators::ProjectValidator.new
      validator.validate(project)

      expect(project).not_to be_valid
    end
  end
end
