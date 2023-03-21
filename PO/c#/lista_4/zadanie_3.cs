/*
	Emilia Wiśniewska
	lista 04: zadanie 3
	mcs zadanie_3.cs
*/

using System.Collections;
using System;
using System.Collections.Generic;

interface IGraph 
{
	bool ExistsEdge(string v1, string v2);
	void AddEdge(string v1, string v2);
	void RemoveEdge(string v1, string v2);
	int NumberOfVertex(string v1);
	string NameOfVertex(int i);
	void RadomGraph(int numberOfVertices, int numberOfEdges);
	int VerticesCount();
	List<string> AllVertices();
	void RenameVertex(string previousName, string newName);
}

class GraphMatrix : IGraph
{
	int[,] matrix;
	List<string> vertices;

	public List<string> AllVertices()
	{
		return vertices;
	}

	public void RadomGraph(int numberOfVertices, int numberOfEdges)
	{
		//utworzenie wierzcholkow
		matrix = new int[numberOfVertices, numberOfVertices];
		
		Random rand = new Random();
		for(int i = 0; i < numberOfVertices; i++)
		{
			for(int j = i + 1; j < numberOfVertices; j++)
			{
				matrix[i,j] = 0;
				matrix[j,i] = 0;
			}
		}
		//losowe krawedzie
		while(numberOfEdges > 0)
		{
			int v1 = rand.Next() % numberOfVertices;
			int v2 = rand.Next() % numberOfVertices;
			if(v1 != v2)
			{
				matrix[v1,v2] = 1;
				matrix[v2,v1] = 1;
				numberOfEdges--;
			}
		}

		//nazwy wierzcholkow
		vertices = new List<string>();
		for(int i = 0; i < numberOfVertices; i++)
		{
			vertices.Add("v" + i.ToString());
		}
	}

	public int NumberOfVertex(string v1)
	{
		for(int i = 0; i < vertices.Count; i++)
		{
			if(vertices[i] == v1){return i;}
		}
		return -1;
	}

	public string NameOfVertex(int i)
	{
		return vertices[i];
	}

	public bool ExistsEdge(string v1, string v2)
	{
		return (matrix[NumberOfVertex(v1), NumberOfVertex(v2)] == 1);
	}

	public void AddEdge(string v1, string v2)
	{
		int i1 = NumberOfVertex(v1);
		int i2 = NumberOfVertex(v2);
		matrix[i1,i2] = 1;
		matrix[i2,i1] = 1;
	}

	public void RemoveEdge(string v1, string v2)
	{
		int i1 = NumberOfVertex(v1);
		int i2 = NumberOfVertex(v2);
		matrix[i1,i2] = 0;
		matrix[i2,i1] = 0;
	}

	public int VerticesCount()
	{
		return vertices.Count;
	}

	public void RenameVertex(string previousName, string newName)
	{
		if(NumberOfVertex(previousName) == -1)
		{
			return;
		}
		vertices[NumberOfVertex(previousName)] = newName;
	}
}

class GraphListsOfNeighbords : IGraph
{
	List<List<int>> edges = new List<List<int>>();
	List<string> vertices;

	public List<string> AllVertices()
	{
		return vertices;
	}

	public void RadomGraph(int numberOfVertices, int numberOfEdges)
	{
		//utworzenie wierzcholkow
		for(int i = 0; i < numberOfVertices; i++)
		{
			edges.Add(new List<int>());
		}

		//losowe krawedzie
		Random rand = new Random();
		while(numberOfEdges > 0)
		{
			int v1 = rand.Next() % numberOfVertices;
			int v2 = rand.Next() % numberOfVertices;
			if(v1 != v2)
			{
				edges[v1].Add(v2);
				edges[v2].Add(v1);
				numberOfEdges--;
			}
		}

		//nazwy wierzcholkow
		vertices = new List<string>();
		for(int i = 0; i < numberOfVertices; i++)
		{
			vertices.Add("v" + i.ToString());
		}
	}

	public int NumberOfVertex(string v1)
	{
		for(int i = 0; i < vertices.Count; i++)
		{
			if(vertices[i] == v1){return i;}
		}
		return -1;
	}

	public string NameOfVertex(int i)
	{
		return vertices[i];
	}

	public bool ExistsEdge(string v1, string v2)
	{
		foreach (int vertex in edges[NumberOfVertex(v1)])
		{
			if(vertex == NumberOfVertex(v2)){return true;}
		}
		return false;
	}

	public void AddEdge(string v1, string v2)
	{
		int i1 = NumberOfVertex(v1);
		int i2 = NumberOfVertex(v2);
		edges[i1].Add(i2);
		edges[i2].Add(i1);
	}

	public void RemoveEdge(string v1, string v2)
	{
		int i1 = NumberOfVertex(v1);
		int i2 = NumberOfVertex(v2);
		edges[i1].Remove(i2);
		edges[i2].Remove(i1);
	}

	public int VerticesCount()
	{
		return vertices.Count;
	}

	public void RenameVertex(string previousName, string newName)
	{
		if(NumberOfVertex(previousName) == -1)
		{
			return;
		}
		vertices[NumberOfVertex(previousName)] = newName;
	}
}

class GraphOperations
{
	public void CreateRandom(IGraph g, int vert, int edges)
	{
		g.RadomGraph(vert, edges);
	}

	public List<string> ShortestPath(IGraph g, string a, string b)
	{
		List<string> path = new List<string>();
		if(g.NumberOfVertex(a) == -1 || g.NumberOfVertex(b) == -1)
		{
			return path;
		}
		Queue q = new Queue();
		int[] connections = new int[g.VerticesCount()];
		for(int i = 0; i < g.VerticesCount(); i++)
		{
			connections[i] = -1;
		}

		List<string> verts = g.AllVertices();
		//najkrotsza sciezka (BFS)
		q.Enqueue(a); //dodanie pierwszego
		connections[g.NumberOfVertex(a)] = g.NumberOfVertex(a);
		string v = a;
		while(q.Count > 0) // dopoki jest cos w kolejce
		{
			v = (string)q.Peek();
			q.Dequeue();
			foreach (string w in verts)
			{
				if(v != w && g.ExistsEdge(w,v))
				{
					if(w == b) //jesli to koniec drogi
					{
						connections[g.NumberOfVertex(w)] = g.NumberOfVertex(v);
						q = new Queue(); //zeby na pewno wyszlo z whilea
						break;
					}
					if(connections[g.NumberOfVertex(w)] == -1) //w w jeszcze nie bylismy
					{
						connections[g.NumberOfVertex(w)] = g.NumberOfVertex(v);
						q.Enqueue(w);
					}
				}
			}
		}


		//recreate path
		if(connections[g.NumberOfVertex(b)] == -1)
		{
			return path;
		}
		v = b;
		while(v != a)
		{
			path.Add(v);
			v = g.NameOfVertex(connections[g.NumberOfVertex(v)]);
		}
		path.Add(a);
		return path;
	}
}

class Program
{
	public static void Main()
	{
		//stworzenie obiektow
		GraphMatrix graph = new GraphMatrix();
		GraphListsOfNeighbords graph2 = new GraphListsOfNeighbords();
		GraphOperations operacje = new GraphOperations();

		//uwtorzenie losowych grafow i zamiana nazw wierzcholkow w jednym z nich
		operacje.CreateRandom(graph, 50, 80);
		List<string> vert = graph.AllVertices();
		for(int i = 0; i < vert.Count; i++)
		{
			graph.RenameVertex(vert[i], ("new-" + vert[i]));
		}
		operacje.CreateRandom(graph2, 33, 40);

		//sprawdzenie jaka jest najkrotsza sciezka (jesli jest) miedzy pierwszym a drugim wierzcholkiem
		Console.WriteLine("ścieżka w pierwszym grafie: (pusta jesli nie istnieje)");
		List<string> path1  = operacje.ShortestPath(graph, graph.NameOfVertex(1), graph.NameOfVertex(2));
		foreach (string v in path1)
		{
			Console.WriteLine(v);
		}

		Console.WriteLine("ścieżka w drugim grafie: (pusta jesli nie istnieje)");
		List<string> path2  = operacje.ShortestPath(graph2, graph2.NameOfVertex(1), graph2.NameOfVertex(2));
		foreach (string v in path2)
		{
			Console.WriteLine(v);
		}
	}
}

//NaN != Nan 