require 'spec_helper'

RSpec.describe 'creating models' do
  let(:client) { JSONAPIAppClient.new }
  let(:connection) { client.connection }

  def fetch_authors
    JSONAPIAppClient::Author.fetch_all(connection: connection)
  end

  def fetch_author(id)
    JSONAPIAppClient::Author.fetch(
      connection: connection,
      url_opts: { id: id }
    )
  end

  def create_author
    JSONAPIAppClient::Author.create(
      attributes: { name: name },
      connection: connection
    )
  end

  def create_post(author:, title:, text:)
    JSONAPIAppClient::Post.create(
      attributes: { title: title, text: text },
      relationships: { author: author },
      connection: connection
    )
  end

  describe 'creating an Author' do
    context 'Given valid parameters' do
      let(:name) { 'Filbert' }

      it 'creates the Author' do
        expect { create_author }.to change { fetch_authors.size }.by(1)
      end

      it "preserves the Author's attributes" do
        author = create_author
        expect(author.name).to eq(name)
        reloaded_author = fetch_author(author.id)
        expect(reloaded_author.name).to eq(name)
      end
    end

    context 'Given invalid parameters' do
      let(:name) { 'TOOLONGNAME' * 500 }

      it 'fails to create the Author' do
        expect { create_author }.to raise_error { SimpleJSONAPIClient::Base::UnprocessableEntityError }
      end
    end
  end

  describe 'creating a Post' do
    context 'Given an Author already exists' do
      let!(:author) { create_author }
      let(:name) { 'Filbert' }
      let(:title) { 'A Very Proper Post Title' }
      let(:text) { 'I am absolutely incensed about something.' }

      it 'creates a Post associated with that Author' do
        post = create_post(author: author, title: title, text: text)
        expect(author.posts.first.id).to eq(post.id)
      end
    end
  end
end