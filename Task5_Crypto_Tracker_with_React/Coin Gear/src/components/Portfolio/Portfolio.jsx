import React from 'react';
import {
  Box,
  Table,
  Thead,
  Tbody,
  Tr,
  Th,
  Td,
  Image,
  Text,
  HStack,
  Button,
  Heading,
  TableContainer,
  Alert,
  AlertIcon,
} from '@chakra-ui/react';
import { FaTrash } from 'react-icons/fa';

const Portfolio = ({ portfolio = [], onRemoveFromPortfolio }) => {
  if (!Array.isArray(portfolio)) {
    return (
      <Alert status="error" borderRadius="lg">
        <AlertIcon />
        Invalid portfolio data.
      </Alert>
    );
  }

  const calculateTotalValue = () => {
    return portfolio.reduce((total, coin) => {
      const value = coin?.current_price && coin?.amount
        ? coin.current_price * coin.amount
        : 0;
      return total + value;
    }, 0);
  };

  return (
    <Box bg="white" borderRadius="lg" boxShadow="sm" p={6}>
      <HStack justify="space-between" mb={6} wrap="wrap" gap={4}>
        <Heading size="lg">Your Portfolio</Heading>
        <Text fontSize="xl" fontWeight="bold" color="blue.500">
          Total Value: ${calculateTotalValue().toLocaleString()}
        </Text>
      </HStack>

      {portfolio.length === 0 ? (
        <Alert status="info" borderRadius="md">
          <AlertIcon />
          Your portfolio is empty. Add some cryptocurrencies to track their value!
        </Alert>
      ) : (
        <TableContainer>
          <Table variant="simple">
            <Thead>
              <Tr>
                <Th>Coin</Th>
                <Th>Amount</Th>
                <Th>Value</Th>
                <Th>Action</Th>
              </Tr>
            </Thead>
            <Tbody>
              {portfolio.map((coin) => (
                <Tr key={coin?.id || Math.random()}>
                  <Td>
                    <HStack spacing={2}>
                      {coin?.image && (
                        <Image
                          src={coin.image}
                          alt={coin.name}
                          boxSize="24px"
                          fallback={<Box boxSize="24px" bg="gray.200" borderRadius="full" />}
                        />
                      )}
                      <Text fontWeight="medium">{coin?.name || 'Unknown'}</Text>
                      <Text color="gray.500">
                        ({(coin?.symbol || 'N/A').toUpperCase()})
                      </Text>
                    </HStack>
                  </Td>
                  <Td fontWeight="medium">{coin?.amount || 0}</Td>
                  <Td fontWeight="medium">
                    ${((coin?.current_price || 0) * (coin?.amount || 0)).toLocaleString()}
                  </Td>
                  <Td>
                    <Button
                      leftIcon={<FaTrash />}
                      colorScheme="red"
                      size="sm"
                      onClick={() => coin?.id && onRemoveFromPortfolio(coin.id)}
                      variant="outline"
                      isDisabled={!coin?.id}
                    >
                      Remove
                    </Button>
                  </Td>
                </Tr>
              ))}
            </Tbody>
          </Table>
        </TableContainer>
      )}
    </Box>
  );
};

export default Portfolio;