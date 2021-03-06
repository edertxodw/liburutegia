class LibrosController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :acceso_admin, only: [:edit, :update, :destroy, :new]
  before_filter :set_libro, only: [:edit, :update, :show, :destroy]

  # GET /libros
  # GET /libros.json
  def index
    # Muestra x libros por página, busca por un patrón y ordena los productos al clicar en la cabecera de la columna
    @libros = Libro.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 16, :page => params[:page])
  end

  # GET /libros/1
  # GET /libros/1.json
  def show
  end

  # GET /libros/new
  def new
    @libro = Libro.new
  end

  # GET /libros/1/edit
  def edit
  end

  # POST /libros
  # POST /libros.json
  def create
    @libro = Libro.new(libro_params)
    calc_disponibles

    respond_to do |format|
      if @libro.save
        format.html { redirect_to @libro, notice: 'El libro se ha creado correctamente.' }
        format.json { render :show, status: :created, location: @libro }
      else
        format.html { render :new }
        format.json { render json: @libro.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /libros/1
  # PATCH/PUT /libros/1.json
  def update
    respond_to do |format|
      if @libro.update(libro_params)
        format.html { redirect_to root_path, notice: 'El libro se ha actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @libro }
      else
        format.html { render :edit }
        format.json { render json: @libro.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /libros/1
  # DELETE /libros/1.json
  def destroy
    @libro.destroy
    respond_to do |format|
      format.html { redirect_to libros_url, notice: 'El libro se ha eliminado correctamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_libro
      @libro = Libro.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def libro_params
      params.require(:libro).permit(:titulo, :autor, :genero, :isbn, :portada, :fregistro, :cantidad, :disponibles, :idioma)
    end
    
    # Orientación de las columnas
    def sort_column
      Libro.column_names.include?(params[:sort]) ? params[:sort] : "titulo"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
    
    # Calcula el número de libros que hay disponibles
    def calc_disponibles
      # En principio se añaden los que hay en la cantidad
      # hasta que se integre la opción del préstamo
      @libro.disponibles = @libro.cantidad
    end
end
