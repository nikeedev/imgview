module main

import gg
import gx
import os
import term


struct App {
mut:
	ctx    &gg.Context = unsafe { nil }
	img  gg.Image
	file_name string
}

const (
	win_width = 800
	win_height = 600
)

fn main() {

	if os.args.len < 2 {
		println(term.cyan("Usage: imgview <filename>.png/.jpg/.jpeg\n"))
		return
	}
	else {
		mut file_name := os.args[1]

		if !os.exists(file_name) {
			println(term.red("Image ${file_name} doens't exist!\n"))
			return
		}

		mut app := &App{
			ctx: 0,
			file_name: file_name
		}

		app.ctx = gg.new_context(
			bg_color: gx.white
			width: win_width
			height: win_height
			create_window: true
			window_title: "imgview - ${file_name}"
			frame_fn: frame
			user_data: app
			init_fn: init
		)

		app.ctx.run()

	}
}

fn init(mut app &App) {

	app.img = app.ctx.create_image(os.resource_abs_path(app.file_name))

}

fn (app &App) draw() {

	app.ctx.draw_image(0, 0, app.img.width, app.img.height, app.img)

}

fn frame(app &App) {
	app.ctx.begin()
	app.draw()
	app.ctx.end()
}
