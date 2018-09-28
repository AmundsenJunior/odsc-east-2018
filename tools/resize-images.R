# Script to resize image files
# install.packages('magick')
#
# Convert individual images to JPG in order to reference in both local development and deployed app
# library(magick)
# image <- image_read("image-name.png")
# image_write("image, path = "image-name.jpg", format = "jpg")

library(magick)
library(tools)

resize_image <- function(image_path, image_filename, dest_dir = "resized", height_dim = 150) {
  # load image
  original_image <- image_read(file.path(image_path, image_filename))

  # can either scale to specific size, or by relative amount
  # i want to scale the height to 150 pixels, with aspect ratio maintained
  new_image <- image_scale(original_image, paste("x", height_dim, sep = ""))

  # write resized image to same directory
  new_image_filename <- file.path(
    image_path,
    dest_dir,
    paste(
      file_path_sans_ext(image_filename),
      paste(
        height_dim,
        "jpg",
        sep = "."),
      sep = "_")
    )
  dir.create(file.path(image_path, dest_dir), showWarnings = FALSE)
  image_write(new_image, path = new_image_filename, format = "jpg")
}

image_path <- "notes/images"
images <- list.files(image_path)

for(image in list_files_with_exts(image_path, "jpg", full.names = FALSE)) {
  resize_image(image_path, image)
}
