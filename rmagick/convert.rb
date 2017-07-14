require 'RMagick'

files = Dir.glob('./sample2-v.jpg')
files.each do |filename|
  original = Magick::Image.read(filename).first
  originWidth = original.columns
  originHeight = original.rows
  
  # 初期値
  width = 0
  height = 0
  pos = 'center'
  aspectW = 1
  aspectH = 1

  # 入力値例 ： hoge.jpg?w=300&h=400&p=center
  width = 300 # リサイズサイズ 横幅 オリジナル画像サイズ以下
  height = 400 # リサイズサイズ 縦幅 オリジナル画像サイズ以下
  pos = 'center' # クロップ位置

  # 入力値例 ： hoge.jpg?w=500&p=leftabove
#  width = 500 # リサイズサイズ 横幅 オリジナル画像サイズ以下
#  pos = 'leftabove' # クロップ位置

  # 入力値例 ： hoge.jpg?h=100&p=rightbelow
#  height = 100 # リサイズサイズ 縦幅 オリジナル画像サイズ以下
#  pos = 'rightbelow' # クロップ位置

  # 入力値例 ： hoge.jpg?w=60000&h=400&p=rightbelow → オリジナルより大きい場合無視される
#  width = 60000 # リサイズサイズ 横幅 オリジナル画像サイズ以下
#  height = 400 # リサイズサイズ 縦幅 オリジナル画像サイズ以下
#  pos = 'rightbelow' # クロップ位置

  # 演算
  if width > 0 && height > 0 then
    aspectW = width / height.to_f.round(3)
    aspectW = aspectW > 1 ? 1 : aspectW
    aspectH = height / width.to_f.round(3)
    aspectH = aspectH > 1 ? 1 : aspectH
  end
  originNarrower = originWidth > originHeight ? originHeight : originWidth
  narrower = width > height ? height : width
  wider = width > height ? width : height
  
  if pos == 'center' then
    grav = Magick::CenterGravity
  elsif pos == 'leftabove' then
    grav = Magick::NorthWestGravity
  elsif pos == 'rightbelow' then
    grav = Magick::SouthEastGravity
  end
  
  # log
  puts aspectW
  puts aspectH
  puts originWidth
  puts originHeight
  puts narrower
  puts wider
  puts pos
  
  # crop
  if width > 0 && height > 0 then
    image = original.crop(grav, originNarrower * aspectW, originNarrower * aspectH)
  end
  
  # resize
  if width > 0 && originWidth >= width && height > 0 && originHeight >= height then
    image = image.resize(width, height)
  elsif width > 0 then
    image = image.resize(width, width)
  elsif height > 0 then
    image = image.resize(height, height)
  end
  
  # write
  if width > 0 && height > 0 then
    image.write('new.jpg')
  end
  
end