# Script to resize image files
# install.packages('remotes')
# remotes::install_bioc('EBImage')
# install.packages('tools')

library("EBImage")
library("tools")

resize_image <- function(image_path, image_filename, dest_dir = "resized", height_dim = 150) {
  # load image
  original_image <- readImage(file.path(image_path, image_filename))

  # can either scale to specific size, or by relative amount
  # i want to scale the height to 150 pixels, with aspect ratio maintained
  new_image <- resize(original_image, h = 150)

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
  writeImage(new_image, new_image_filename)
}

image_path <- "notes/images"
images <- list.files(image_path)

for(image in list_files_with_exts(image_path, c('jpg', 'jpeg', 'png'), full.names = FALSE)) {
  resize_image(image_path, image)
}
