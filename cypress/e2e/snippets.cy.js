describe('Snippets App', () => {
  beforeEach(() => {
    cy.visit('/');
  });

  it('renders header with title and both buttons', () => {
    cy.contains('h1', 'Snippets');
    cy.contains('button', 'Paste');
    cy.contains('button', 'Load');
  });

  it('sidebar renders both sections and applies active state on click', () => {
    cy.contains('.sidebar-item', 'All Snippets').should('have.class', 'active');
    cy.contains('.sidebar-item', 'Recent').click();
    cy.contains('.sidebar-item', 'Recent').should('have.class', 'active');
    cy.contains('.sidebar-item', 'All Snippets').should(
      'not.have.class',
      'active',
    );
  });

  it('shows empty state when no snippets exist', () => {
    cy.contains('No snippets yet');
  });

  it('deletes a card when Delete is clicked', () => {
    cy.window().then((win) => {
      cy.stub(win.navigator.clipboard, 'readText').resolves('Hello world');
    });
    cy.contains('button', 'Paste').click();
    cy.contains('Hello world').should('exist');
    cy.contains('button', 'Delete').click();
    cy.contains('Hello world').should('not.exist');
    cy.contains('No snippets yet').should('exist');
  });
});
