public class HelloWorld {
    public static String sayHello(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!!';
        }
        return 'Hello, ' + name.trim() + '!';
    }
}