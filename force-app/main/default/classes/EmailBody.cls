public class EmailBody {

	public class Destination {
		public List<String> ToAddresses;
	}

	public Content Content;
	public Destination Destination;
	public String FromEmailAddress;

	public class Content {
		public Simple Simple;
	}

	public class Html {
		public String Data;
	}

	public class Body {
		public Html Html;
		public Html Text;
	}

	public class Simple {
		public Body Body;
		public Html Subject;
	}

	
	public static EmailBody parse(String json) {
		return (EmailBody) System.JSON.deserialize(json, EmailBody.class);
	}
}