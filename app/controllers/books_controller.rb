class BooksController < ApplicationController
    before_action :set_book, only: [:show, :update, :destroy]
  
    def index
      books = Book.all
      render json: BookBlueprint.render(books), status: :ok
    end
  
    def show
      render json: BookBlueprint.render(@book), status: :ok
    end
  
    def create
      book = Book.new(book_params)
      if book.save
        render json: BookBlueprint.render(book), status: :created
      else
        render json: book.errors, status: :unprocessable_entity
      end
    end
  
    def update
      if @book.update(book_params)
        render json: BookBlueprint.render(@book), status: :ok
      else
        render json: @book.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @book.destroy
      head :no_content
    end
  
    private
  
    def set_book
      @book = Book.find_by(id: params[:id])
      return render json: { error: "Not found" }, status: :not_found unless @book
    end
  
    def book_params
      params.require(:book).permit(:title, :author, :read)
    end
  end
  