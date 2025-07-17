require 'rails_helper'

RSpec.describe "Books API", type: :request do
  let!(:books) { create_list(:book, 3) }
  let(:book_id) { books.first.id }

  describe "GET /books" do
    it "returns all books with status 200 and correct structure" do
      get "/books"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(3)
      expect(json.first).to include("id", "title", "author", "read")
    end
  end

  describe "GET /books/:id" do
    it "returns the book with correct structure and status 200" do
      get "/books/#{book_id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to include("id" => book_id, "title" => books.first.title, "author" => books.first.author, "read" => books.first.read)
    end

    it "returns 404 if book not found" do
      get "/books/99999"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /books" do
    let(:valid_params) { { book: { title: "New Book", author: "Author Name", read: false } } }

    it "creates a book, returns 201 and increases count" do
      expect {
        post "/books", params: valid_params
      }.to change(Book, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json).to include("title" => "New Book", "author" => "Author Name", "read" => false)
    end

    it "returns 422 for invalid data" do
      post "/books", params: { book: { title: "", author: "", read: nil } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /books/:id" do
    let(:update_params) { { book: { title: "Updated Title", read: true } } }

    it "updates the book and returns 200 with updated attributes" do
      patch "/books/#{book_id}", params: update_params

      expect(response).to have_http_status(:ok)
      updated_book = Book.find(book_id)
      expect(updated_book.title).to eq("Updated Title")
      expect(updated_book.read).to be true
    end

    it "returns 404 for nonexistent book" do
      patch "/books/99999", params: update_params
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /books/:id" do
    it "deletes the book and returns 204 with count decreased" do
      expect {
        delete "/books/#{book_id}"
      }.to change(Book, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 if book not found" do
      delete "/books/99999"
      expect(response).to have_http_status(:not_found)
    end
  end
end

