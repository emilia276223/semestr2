using System.Collections;
using System;
using System.Collections.Generic;

interface IGraph 
{
	// List<string> vertices; //here are translation number - string for vertices
	bool ExistsEdge(string v1, string v2);
	void AddEdge(string v1, string v2);
	void RemoveEdge(string v1, string v2);
	int NumberOfVertex(string v1);
	string NameOfVertex(int i);
}

class GraphMatrix : IGraph
{
	int[][] matrix;
	List<string> vertices;
	public GraphMatrix(int numberOfVertices, List<string> namesOfVertices)
	{
		for(int i = 0; i < numberOfVertices; i++)
		{
			for(int j = 0; j < numberOfVertices; j++)
			{
				matrix[i][j] = 0;
			}
		}
		vertices = namesOfVertices;
	}

	int IGraph.NumberOfVertex(string v1)
	{
		for(int i = 0; i < vertices.Count; i++)
		{
			if(vertices[i] == v1){return i;}
		}
		return -1;
	}

	string IGraph.NameOfVertex(int i)
	{
		return vertices[i];
	}

	bool IGraph.ExistsEdge(string v1, string v2)
	{
		return (matrix[IGraph.NumberOfVertex(v1)][IGraph.NumberOfVertex(v2)] == 1);
	}

	void IGraph.AddEdge(string v1, string v2)
	{
		int i1 = IGraph.NumberOfVertex(v1);
		int i2 = IGraph.NumberOfVertex(v2);
		matrix[i1][i2] = 1;
		matrix[i2][i1] = 1;
	}

	void IGraph.RemoveEdge(string v1, string v2)
	{
		int i1 = IGraph.NumberOfVertex(v1);
		int i2 = IGraph.NumberOfVertex(v2);
		matrix[i1][i2] = 0;
		matrix[i2][i1] = 0;
	}
}

class GraphListsOfNeighbords : IGraph
{
	// List<string> vertices;
}

// class GraphOperations
// {

// }

class Program
{
	public static void Main()
	{
		Console.Write("Hello World");
	}
}