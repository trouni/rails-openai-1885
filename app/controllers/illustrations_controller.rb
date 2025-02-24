class IllustrationsController < ApplicationController
  def create
    @character = Character.find(params[:character_id])
    detailed_situation = GenerateSituation.new(@character.description, params[:situation]).call
    # Call OpenAI to generate an Image
    url = GenerateIllustration.new(detailed_situation).call
    # Attach the image to the character
    @character.attach_illustration_from_url(url)
    redirect_to character_path(@character)
  end

  def destroy
    @illustration = ActiveStorage::Attachment.find(params[:id])
    @character = @illustration.record
    @illustration.purge
    redirect_to character_path(@character), notice: 'The illustration has been deleted!'
  end
end
