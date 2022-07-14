class BooksController < ApplicationController
  impressionist :actions=> [:show]

  def show
    @book = Book.find(params[:id])
    impressionist(@book, nil, unique: [:session_hash])
    @book_new = Book.new
    @user = @book.user
    @post_comment = PostComment.new
  end

  def index
    if params[:latest]
      @books = Book.latest
    else
      @books = Book.rating
    end
    @book_new = Book.new
  end

  #いいね順に並び替え
  #def index
  #  to  = Time.current.at_end_of_day
  #  from  = (to - 6.day).at_beginning_of_day
  #  @books = Book.includes(:favorited_users).
  #    sort {|a,b|
  #      b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
  #      a.favorited_users.includes(:favorites).where(created_at: from...to).size
  #    }
  #  @book_new = Book.new
  #end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user == current_user
    else
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def search_book
    @book = Book.new
    @books = Book.looks(params[:keyword])
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :category, :rate)
  end
end
