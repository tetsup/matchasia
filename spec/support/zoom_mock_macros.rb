module ZoomMockMacros
  def zoom_mock
    dummy_user_id = 'samplezoomuserid123456'
    meeting_info = {
      'start_url' => 'https://example.com/start_url_dummy',
      'join_url' => 'https://example.com/join_url_dummy',
    }
    allow_any_instance_of(Teacher).to receive(:create_zoom_user).and_return(true)
    allow_any_instance_of(Teacher).to receive(:zoom_user_id).and_return(dummy_user_id)
    allow_any_instance_of(Teacher).to receive(:zoom_user_available?).and_return(true)
    allow_any_instance_of(Reservation).to receive(:create_zoom_meeting).and_return(meeting_info)
  end
end
