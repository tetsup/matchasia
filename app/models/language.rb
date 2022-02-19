class Language < ActiveHash::Base
  self.data = [
    { id: 1, name: '中国語' },
    { id: 2, name: 'ベトナム語' },
    { id: 3, name: 'タイ語' },
    { id: 4, name: 'ミャンマー語' },
    { id: 5, name: 'フィリピン語' }
  ]
end
