package com.soen387.poll;

public class PollNotFoundException extends PollException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public PollNotFoundException() {
		
	}
	
	public PollNotFoundException(String message) {
		super(message);
	}

}
