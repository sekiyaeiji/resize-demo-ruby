# convert.rb
# 
##### run
# 
# $ ruby convert.rb
# 

require 'RMagick'

files = Dir.glob('./sample2-v.jpg')
files.each do |filename|
  original = Magick::Image.read(filename).first
  image = original
  
  originWidth = original.columns
  originHeight = original.rows
  
  originNarrower = [originWidth, originHeight].min
  originWider = [originWidth, originHeight].max
  originAspectW = (originWidth / originHeight.to_f).round(3)
  originAspectH = (originHeight / originWidth.to_f).round(3)
  
  # 初期値
  width = 0
  height = 0
  pos = ''
  aspectW = 1
  aspectH = 1

  # 入力値
  # 入力値例 ： hoge.jpg?w=300&h=400&p=center
  width = 200 # リサイズサイズ 横幅 オリジナル画像サイズ以下
  height = 600 # リサイズサイズ 縦幅 オリジナル画像サイズ以下
  pos = 'center' # クロップ位置

  # 入力値例 ： hoge.jpg?w=60000&h=400&p=rightdown → オリジナルより大きい場合
#  width = 60000 # リサイズサイズ 横幅 オリジナル画像サイズ以下 → オリジナル横幅値に置換
#  height = 400 # リサイズサイズ 縦幅 オリジナル画像サイズ以下
#  pos = 'rightdown' # クロップ位置

  # 入力値例 ： hoge.jpg?w=400 → リサイズのみ行う
#  width = 400 # リサイズサイズ 縦幅 オリジナル画像サイズ以下
  
  # 演算
  # 上限設定
  width = [width, originWidth].min
  height = [height, originHeight].min
  # アスペクト比
  if width > 0 && height > 0 then
    aspectW = (width / height.to_f).round(3)
    aspectNW = [aspectW, 1].min.round(3)
    aspectH = (height / width.to_f).round(3)
    aspectNH = [aspectH, 1].min.round(3)
  end
  # 比較
  narrower = [width, height].min
  wider = [width, height].max
  
  # crop position
  if pos == 'center' || pos == 'c' then
    grav = Magick::CenterGravity
  elsif pos == 'leftup' || pos == 'lu' || pos == 'upleft' || pos == 'ul' then
    grav = Magick::NorthWestGravity
  elsif pos == 'rightdown' || pos == 'rd' || pos == 'downright' || pos == 'dr' then
    grav = Magick::SouthEastGravity
  elsif pos == 'up' || pos == 'u' then
    grav = Magick::NorthGravity
  elsif pos == 'down' || pos == 'd' then
    grav = Magick::SouthGravity
  elsif pos == 'left' || pos == 'l' then
    grav = Magick::WestGravity
  elsif pos == 'right' || pos == 'r' then
    grav = Magick::EastGravity
  end
  
  # log
  puts '■ width'
  puts width
  puts '■ height'
  puts height
  puts '■ pos'
  puts pos
  puts '■ aspectW'
  puts aspectW
  puts '■ aspectH'
  puts aspectH
  puts '■ aspectNW'
  puts aspectNW
  puts '■ aspectNH'
  puts aspectNH
  puts '■ narrower'
  puts narrower
  puts '■ wider'
  puts wider
  puts '■ originAspectW'
  puts originAspectW
  puts '■ originAspectH'
  puts originAspectH


  # crop
  if width > 0 && height > 0 && pos != '' then
    widthValue = originAspectW > aspectW ? originWider : originNarrower
    
    puts '■ widthValue'
    puts widthValue
    
    cropWidth = originAspectW > aspectW ? widthValue * aspectNW : widthValue
    cropHeight = originAspectW > aspectW ? widthValue : widthValue * aspectNH / aspectNW

    puts '■ cropWidth'
    puts cropWidth.round()
    puts '■ cropHeight'
    puts cropHeight.round()
    
    image = original.crop(grav, cropWidth.round(), cropHeight.round())
  end


  # resize
  if width > 0 || height > 0 then
    newWidth = height == 0 ? height * originAspectW : width
    newHeight = width == 0 ? width * originAspectH : height
#    image = image.resize(newWidth, newHeight)
  end


  # write
  image.write('new.jpg')
  
end