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

  # 入力値例 ： hoge.jpg?w=300&h=400&p=center
  width = 200 # リサイズサイズ 横幅 オリジナル画像サイズ以下
  height = 600 # リサイズサイズ 縦幅 オリジナル画像サイズ以下
  pos = 'lu' # クロップ位置

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
    aspectW = width / height.to_f
    aspectW = [aspectW, 1].min.round(3)
    aspectH = height / width.to_f
    aspectH = [aspectH, 1].min.round(3)
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
  puts '■ originWidth'
  puts originWidth
  puts '■ originHeight'
  puts originHeight
  puts '■ width'
  puts width
  puts '■ height'
  puts height
  puts '■ aspectW'
  puts aspectW
  puts '■ aspectH'
  puts aspectH
  puts '■ originAspectW'
  puts originAspectW
  puts '■ originAspectH'
  puts originAspectH
  puts '■ narrower'
  puts narrower
  puts '■ wider'
  puts wider
  puts '■ originNarrower'
  puts originNarrower
  puts '■ originWider'
  puts originWider
  puts '■ pos'
  puts pos
  
  # crop
  if width > 0 && height > 0 && pos != '' then
    puts '■ boolean'
    puts ((originAspectW >= 1 && aspectW >= 1) || (originAspectH >= 1 && aspectH >= 1))
    widthValue = ((originAspectW >= 1 && aspectW >= 1) || (originAspectH >= 1 && aspectH >= 1)) ? originNarrower : originWider
    puts '■ widthValue * aspectW'
    puts widthValue * aspectW
    puts '■ widthValue * aspectH'
    puts widthValue * aspectH
    image = original.crop(grav, [widthValue * aspectW, originWidth].min, [widthValue * aspectH, originHeight].min)
  end

  # resize
  if width > 0 && height > 0 then
    newWidth = width
    newHeight = height
  elsif width > 0 then
    newWidth = width
    newHeight = width * originAspectH
  elsif height > 0 then
    newWidth = height * originAspectW
    newHeight = height
  end
  if defined?(newWidth) && defined?(newHeight) then
#    image = image.resize(newWidth, newHeight)
  end
  
  # write
  image.write('new.jpg')
  
end