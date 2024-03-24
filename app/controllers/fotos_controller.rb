class FotosController < ApplicationController

  def index
    @fotos = Foto.order(ordem: :desc)
    @lista_ordem = []
  end

  def new
    @foto = Foto.new
  end

  def create
    @foto = Foto.new(foto_params)

    if @foto.save
      redirect_to fotos_path, notice: 'Foto was successfully uploaded.'
    else
      # In case the client request fails but an image was create
      if @foto.imagem != nil
        File.delete(Rails.root.join('app', 'assets', 'images', @foto.imagem))
      end

      render :new
    end
  end

  def show
    @foto = Foto.find(params[:id])
  end

  def update_ordem
    lista = params[:lista_ordem].values
    fotos = Foto.order(ordem: :desc)

    lista.each_with_index do |ordem, index|
      # Need an error treatment here
      fotos[index].update_attribute(:ordem, ordem)
    end

    redirect_to "/", notice: "Update was successfull"
  end

  def destroy
    @foto = Foto.find(params[:id])
    File.delete(Rails.root.join('app', 'assets', 'images', @foto.imagem))
    @foto.destroy
    redirect_to fotos_path, notice: 'Foto excluída com sucesso.'
  end

  def carrossel
    # Pode melhorar a performace
    fotos = Foto.order(ordem: :desc)
    @list_fotos = []
    fotos.each do |foto|
      @list_fotos.push("assets/"+foto.imagem)
    end

    render 'carrossel'
  end

  private

  def foto_params

    # in case the client don't upload a photo
    if not(params[:foto].present?)
      return nil
    end

    imagem = params[:foto][:imagem]
    nome_arquivo = Time.now.to_i.to_s + imagem.original_filename
    arquivo_path = Rails.root.join('app', 'assets', 'images', nome_arquivo)

    File.open(arquivo_path, 'wb') do |file|
      file.write(imagem.read)
    end

    maior_ordem = Foto.maximum(:ordem)
    ordem = maior_ordem ? maior_ordem+1 : 1 # if maior_ordem is null ordem equals 1

    parametros = params.require(:foto).permit(:ordem)
    parametros[:ordem] = ordem
    parametros.merge(imagem: nome_arquivo)

  end
end
