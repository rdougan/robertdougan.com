class SenchaController < ApplicationController
    def index
        @product = params[:product]

        if @product
            @stuff = Dir["public/sencha/#{@product}/*.html"]
        else
            @stuff = Dir["public/sencha/**"]
        end
    end

    def example

    end
end
