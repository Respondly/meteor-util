describe 'Util.path', ->
  describe 'handling package namespace delimiter', ->
    it 'converts : to _', ->
      path = Util.path.packageImage('phil:foo', 'foo/image.png')
      expect(path).to.equal '/packages/phil_foo/images/foo/image.png'

    it 'handles _', ->
      path = Util.path.packageImage('phil_foo', 'foo/image.png')
      expect(path).to.equal '/packages/phil_foo/images/foo/image.png'

    it 'has nothing to convert', ->
      path = Util.path.packageImage('foo', 'image.png')
      expect(path).to.equal '/packages/foo/images/image.png'


  describe 'removing prefixes', ->
    it 'removes "/" prefix from path', ->
      path = Util.path.packageImage('foo', '/image.png')
      expect(path).to.equal '/packages/foo/images/image.png'

    it 'removes "///" prefix from path', ->
      path = Util.path.packageImage('foo', '///image.png')
      expect(path).to.equal '/packages/foo/images/image.png'

    it 'removes "/images" prefix from path', ->
      path = Util.path.packageImage('foo', '/images/image.png')
      expect(path).to.equal '/packages/foo/images/image.png'

    it 'removes "///images" prefix from path', ->
      path = Util.path.packageImage('foo', '///images/image.png')
      expect(path).to.equal '/packages/foo/images/image.png'

