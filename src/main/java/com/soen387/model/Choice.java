package com.soen387.model;

public class Choice {
	
	private String text;
	private String description;
	private int number;

	public void setText(String text) {
		this.text = text;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Choice() {
		text = "";
		description = "";
	}

	public int getNumber() {
		return number;
	}

	public void setNumber(int number) {
		this.number = number;
	}

	public Choice(String _text, String _description) {
		text = _text;
		description = _description;
	}

	public Choice(Choice choice) {
		text = choice.getText();
		description = choice.getDescription();
	}
	
	public String getText() {
		return text;
	}
	
	public String getDescription() {
		return description;
	}
}
